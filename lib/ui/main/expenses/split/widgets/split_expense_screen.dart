import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/components/BasicTextField.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/ui/core/ui/bottom_action_bar.dart';
import 'package:my_travel_app/ui/core/ui/section_header.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/expenses/split/view_models/split_expense_viewmodel.dart';

/// 1人がまとめて払ったときに、メンバーごとの金額を1画面で入力する
class SplitExpenseScreen extends StatefulWidget {
  final SplitExpenseViewModel viewModel;

  const SplitExpenseScreen({super.key, required this.viewModel});

  @override
  State<SplitExpenseScreen> createState() => _SplitExpenseScreenState();
}

class _SplitExpenseScreenState extends State<SplitExpenseScreen> {
  /* 支払者はuidで持つ(メンバーが再読み込みされてもDropdownの値がずれないように) */
  late String? _payerUid;
  final TextEditingController _commonItemController = TextEditingController();

  /* key: uid。メンバーは後から読み込まれることがあるので、必要になったときに作る */
  final Map<String, TextEditingController> _itemControllers = {};
  final Map<String, TextEditingController> _amountControllers = {};

  TextEditingController _itemController(String uid) => _itemControllers.putIfAbsent(uid, TextEditingController.new);

  TextEditingController _amountController(String uid) => _amountControllers.putIfAbsent(uid, TextEditingController.new);

  @override
  void initState() {
    super.initState();
    /* 支払者は自分 */
    _payerUid = widget.viewModel.uid;
  }

  @override
  void dispose() {
    _commonItemController.dispose();
    for (final controller in [..._itemControllers.values, ..._amountControllers.values]) {
      controller.dispose();
    }
    super.dispose();
  }

  double get _total {
    return widget.viewModel.selectedMembers.fold(
      0,
      (sum, member) => sum + (double.tryParse(_amountController(member.core.uid).text) ?? 0),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    final viewModel = widget.viewModel;
    final result = viewModel.createExpensesFromInput(
      payer: viewModel.memberByUid(_payerUid),
      commonItem: _commonItemController.text,
      inputs: viewModel.selectedMembers
          .map(
            (member) => SplitExpenseInput(
              member: member,
              item: _itemController(member.core.uid).text,
              amount: _amountController(member.core.uid).text,
            ),
          )
          .toList(),
    );
    if (!result.isSuccess || result.data == null) {
      _showSnackBar(result.error?.errorMessage ?? "Unknown Error. It seems to be a coding error.");
      return;
    }

    final expenses = result.data!;
    final saveResult = await viewModel.saveExpenses(expenses);
    if (!mounted) return;
    if (saveResult.isSuccess) {
      _showSnackBar("${expenses.length}件の費用を保存しました");
      context.pop();
    } else {
      _showSnackBar(saveResult.error?.errorMessage ?? "Unknown error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final hintStyle = TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant);
        return Scaffold(
          appBar: TopAppBar(automaticallyImplyLeading: true, title: "まとめて追加"),
          body: LoadingOverlay(
            isLoading: viewModel.isSaving,
            /* メンバー数は少ないので全部組み立てる(ListViewだと画面外の行が作られない) */
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionHeader(icon: Icons.receipt_long_outlined, title: "まとめて払った内容"),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    /* メンバーがまだ読み込まれていないときはnull */
                    initialValue: viewModel.memberByUid(_payerUid) != null ? _payerUid : null,
                    decoration: const InputDecoration(
                      labelText: "支払った人",
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                    items: viewModel.groupMembers.map((member) {
                      return DropdownMenuItem<String>(
                        value: member.core.uid,
                        child: Text(member.displayName, maxLines: 1, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (String? uid) {
                      setState(() {
                        _payerUid = uid;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  BasicTextField(
                    controller: _commonItemController,
                    hintText: "何に使ったか(共通)",
                    prefixIcon: const Icon(Icons.edit_note),
                    onChanged: (_) {
                      /* 各行のヒントを更新する */
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  SectionHeader(
                    icon: Icons.group_outlined,
                    title: "誰の分？",
                    trailing: "${viewModel.selectedMembers.length}人",
                  ),
                  /* チェックした人の入力欄が追加される */
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: viewModel.rowMembers.map((member) {
                      final uid = member.core.uid;
                      return FilterChip(
                        key: ValueKey("select-$uid"),
                        label: Text(member.displayName),
                        selected: viewModel.isSelected(uid),
                        onSelected: (_) => viewModel.toggleMember(uid),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  if (viewModel.selectedMembers.isEmpty)
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text("メンバーを選ぶと入力欄が追加されます", textAlign: TextAlign.center, style: hintStyle),
                      ),
                    )
                  else ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                      child: Text("個別の品目は空なら共通の品目になります", style: hintStyle),
                    ),
                    ...viewModel.selectedMembers.map((member) => _buildMemberRow(member)),
                  ],
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomActionBar(
            label: "まとめて保存",
            onPressed: viewModel.isSaving ? null : _save,
            leading: Row(
              children: [
                Text("${viewModel.selectedMembers.length}件", style: hintStyle),
                const Spacer(),
                Text(
                  "合計 ¥${NumberFormat("#,###").format(_total.round())}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMemberRow(TravelerBasic member) {
    final uid = member.core.uid;
    final commonItem = _commonItemController.text;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
                  child: Text(
                    member.displayName.characters.firstOrNull ?? "?",
                    style: TextStyle(fontSize: 12, color: colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    member.displayName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: BasicTextField(
                    key: ValueKey("item-$uid"),
                    controller: _itemController(uid),
                    hintText: commonItem.isNotEmpty ? commonItem : "品目",
                    onChanged: (_) {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: BasicTextField(
                    key: ValueKey("amount-$uid"),
                    controller: _amountController(uid),
                    keyboardType: TextInputType.number,
                    hintText: "金額",
                    prefixText: "¥ ",
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                    onChanged: (_) {
                      /* 合計を更新する */
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
