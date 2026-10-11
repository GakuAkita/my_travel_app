import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/expenses/result/exchange_tile_list.dart';
import 'package:my_travel_app/ui/main/expenses/result/view_models/expense_result_viewmodel.dart';

import '../../../../../components/ScrollableDialog.dart';
import '../../../../../core/utils/UidColorHelper.dart';
import '../../../../../core/utils/currency_format.dart';
import '../../../../../data/model/traveler/traveler_basic.dart';
import '../../../../core/ui/empty_state.dart';
import '../../../../core/ui/section_header.dart';

class ExpenseResultScreen extends StatefulWidget {
  final ExpenseResultViewModel viewModel;

  const ExpenseResultScreen({super.key, required this.viewModel});

  @override
  State<ExpenseResultScreen> createState() => _ExpenseResultScreenState();
}

class _ExpenseResultScreenState extends State<ExpenseResultScreen> {
  @override
  void initState() {
    super.initState();
    final viewModel = widget.viewModel;
    viewModel.fetchMoneyExchanges(); /* 初期化時に一度だけ呼ぶ */
    viewModel.fetchMoneyExchangesLastUpdated();
    viewModel.fetchBalanceInfo();
  }

  /* "2026-10-11 12:34:56.789" -> "2026/10/11 12:34" */
  String _formatLastUpdated(String? lastUpdated) {
    if (lastUpdated == null) return "-";
    final date = DateTime.tryParse(lastUpdated);
    return date == null ? lastUpdated : DateFormat('yyyy/M/d HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final groupMembers = viewModel.groupMembers();
        final uidColorIndexMap = UidColorHelper.getUidColorIndexMap(groupMembers);

        return Scaffold(
          appBar: TopAppBar(automaticallyImplyLeading: true, title: "割り勘結果"),
          body: viewModel.exchangeList.isEmpty
              ? const EmptyState(
                  icon: Icons.receipt_long_outlined,
                  message: "費用が追加されていません",
                  hint: "費用を追加すると精算方法が表示されます",
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  children: [
                    if (viewModel.isExpensesUpdated)
                      Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: colorScheme.error.withValues(alpha: 0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: colorScheme.error),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.warning_amber_rounded, color: colorScheme.error),
                          title: const Text("費用が更新されました"),
                          subtitle: const Text("一度戻って再度開いてください"),
                        ),
                      ),
                    SectionHeader(
                      icon: Icons.swap_horiz,
                      title: "精算方法",
                      trailing: "最終更新 ${_formatLastUpdated(viewModel.lastUpdated)}",
                    ),
                    ExchangeTileList(exgData: viewModel.exchangeList, groupMembers: groupMembers),
                    const SizedBox(height: 20),
                    /* 基本trueに入るはず。 */
                    if (viewModel.allDetails.isNotEmpty && viewModel.balanceInfo.isNotEmpty) ...[
                      const SectionHeader(icon: Icons.people_outline, title: "メンバーごとの収支"),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                        child: Text(
                          "金額をタップすると内訳が見られます",
                          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                      ...viewModel.allDetails.entries.map((entry) {
                        final uid = entry.key;
                        final profileName = groupMembers.getProfileName(uid);

                        final details = entry.value;
                        final paidTotal = details.fold<double>(0, (sum, d) => sum + d.paidAmount);
                        final owedTotal = details.fold<double>(0, (sum, d) => sum + d.owedAmount);
                        final balance = paidTotal - owedTotal;

                        /* なんとかUI側に伝えたいが、、 */
                        if (balance != viewModel.balanceInfo[uid]?.netTotal) {
                          print("Error!!: $balance != ${viewModel.balanceInfo[uid]?.netTotal}");
                        }

                        return _MemberBalanceCard(
                          name: profileName,
                          avatarColor: UidColorHelper.getColorForUid(uid, uidColorIndexMap),
                          avatarTextColor: UidColorHelper.getTextColorForUid(uid, uidColorIndexMap),
                          paidSum: paidTotal,
                          reimbursedSum: owedTotal,
                          netTotal: balance,
                          onPaidTap: () => _showPaidDetails(context, uid, profileName, paidTotal),
                          onReimbursedTap: () => _showReimbursedDetails(context, uid, profileName, owedTotal),
                        );
                      }),
                    ],
                  ],
                ),
        );
      },
    );
  }

  /* 自分で支払いのやつを表示する */
  void _showPaidDetails(BuildContext context, String uid, String profileName, double paidTotal) {
    final viewModel = widget.viewModel;
    showDialog(
      context: context,
      builder: (context) {
        final paidList = viewModel.buildPaidDetails(uid);
        final isConsistent = paidTotal == viewModel.balanceInfo[uid]?.paidSum;
        return ScrollableDialog(
          head: _DialogHead(title: "支払った金額", name: profileName),
          child: _DetailList(
            rows: [for (final data in paidList) (data.expenseItem, formatYen(data.paidAmount))],
            footer: isConsistent
                ? ("合計", formatYenExact(paidTotal))
                : ("Warning!!!", "$paidTotal != ${viewModel.balanceInfo[uid]?.paidSum}"),
          ),
        );
      },
    );
  }

  /* 支払ってもらったリスト表示する */
  void _showReimbursedDetails(BuildContext context, String uid, String profileName, double owedTotal) {
    final viewModel = widget.viewModel;
    showDialog(
      context: context,
      builder: (context) {
        final reimbursedList = viewModel.buildReimbursedDetails(uid);
        return ScrollableDialog(
          head: _DialogHead(title: "かかった金額", name: profileName),
          child: _DetailList(
            rows: [for (final data in reimbursedList) (data.expenseItem, formatYenExact(data.owedAmount))],
            footer: ("合計", formatYenExact(owedTotal)),
          ),
        );
      },
    );
  }
}

/// メンバー1人分の収支
class _MemberBalanceCard extends StatelessWidget {
  final String name;
  final Color avatarColor;
  final Color avatarTextColor;
  final double paidSum;
  final double reimbursedSum;
  final double netTotal;
  final VoidCallback onPaidTap;
  final VoidCallback onReimbursedTap;

  const _MemberBalanceCard({
    required this.name,
    required this.avatarColor,
    required this.avatarTextColor,
    required this.paidSum,
    required this.reimbursedSum,
    required this.netTotal,
    required this.onPaidTap,
    required this.onReimbursedTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    /* 1円未満は精算なし扱い */
    final settled = netTotal.abs() < 1;
    final receives = netTotal > 0;
    final netColor = settled
        ? colorScheme.onSurfaceVariant
        : receives
        ? colorScheme.primary
        : colorScheme.error;
    final netLabel = settled ? "精算なし" : (receives ? "受け取る" : "払う");

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 16, 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: avatarColor,
                  child: Text(
                    name.length >= 2 ? name.substring(0, 2) : name,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: avatarTextColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(netLabel, style: TextStyle(fontSize: 12, color: netColor)),
                    if (!settled)
                      Text(
                        formatYen(netTotal.abs()),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: netColor),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _AmountButton(label: "払った", amount: paidSum, onTap: onPaidTap),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _AmountButton(label: "かかった", amount: reimbursedSum, onTap: onReimbursedTap),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountButton extends StatelessWidget {
  final String label;
  final double amount;
  final VoidCallback onTap;

  const _AmountButton({required this.label, required this.amount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                  Text(formatYen(amount), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _DialogHead extends StatelessWidget {
  final String title;
  final String name;

  const _DialogHead({required this.title, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(name, maxLines: 1, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

/// 品目と金額の一覧。最後に合計行
class _DetailList extends StatelessWidget {
  final List<(String, String)> rows;
  final (String, String) footer;

  const _DetailList({required this.rows, required this.footer});

  @override
  Widget build(BuildContext context) {
    Widget row(String left, String right, {bool bold = false}) {
      final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(child: Text(left, style: style)),
            const SizedBox(width: 12),
            Text(right, style: style),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (rows.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text("なし", style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
        for (int i = 0; i < rows.length; i++) ...[
          if (i > 0) const Divider(height: 1, indent: 20, endIndent: 20),
          row(rows[i].$1, rows[i].$2),
        ],
        const Divider(height: 1),
        row(footer.$1, footer.$2, bold: true),
      ],
    );
  }
}
