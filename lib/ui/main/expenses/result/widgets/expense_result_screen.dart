import 'package:flutter/material.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/expenses/result/exchange_tile_list.dart';
import 'package:my_travel_app/ui/main/expenses/result/view_models/expense_result_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../../components/ScrollableDialog.dart';
import '../../../../../data/model/traveler/traveler_basic.dart';

class ExpenseResultScreen extends StatefulWidget {
  const ExpenseResultScreen({super.key});

  @override
  State<ExpenseResultScreen> createState() => _ExpenseResultScreenState();
}

class _ExpenseResultScreenState extends State<ExpenseResultScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final viewModel = context.read<ExpenseResultViewModel>();
    viewModel.fetchMoneyExchanges(); /* 初期化時に一度だけ呼ぶ */
    viewModel.fetchMoneyExchangesLastUpdated();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExpenseResultViewModel>();
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true, title: "結果"),
      body: SingleChildScrollView(
        child: Column(
          children:
              viewModel.exchangeList.isEmpty
                  ? [Text("費用が追加されていません")]
                  : [
                    Text("最終更新日: ${viewModel.lastUpdated ?? ""}"),
                    ExchangeTileList(
                      exgData: viewModel.exchangeList,
                      groupMembers: viewModel.groupMembers(),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 20),
                    if (viewModel.allDetails.keys.isNotEmpty) /* 基本trueに入るはず。 */
                      Table(
                        children: [
                          FourRowTableRow(
                            first: Text("名前"),
                            second: Text("払った金額(計)"),
                            third: Text("かかった金額(計)"),
                            fourth: Text("受け取る金額(負の場合は払う)"),
                          ),
                          ...viewModel.allDetails.entries.map((entry) {
                            final uid = entry.key;
                            final profileName = viewModel
                                .groupMembers()
                                .getProfileName(uid);

                            final details = entry.value;
                            final paidTotal = details.fold<double>(
                              0,
                              (sum, d) => sum + d.paidAmount,
                            );
                            final owedTotal = details.fold<double>(
                              0,
                              (sum, d) => sum + d.owedAmount,
                            );

                            final balance = paidTotal - owedTotal;

                            return buildBalancesRow(
                              name: profileName,
                              paidSum: paidTotal,
                              reimbursedSum: owedTotal,
                              netTotal: balance,
                              roundDouble: false,
                              onPaidTap: () {
                                /* 自分で支払いのやつを表示する */
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    final paidList = viewModel.buildPaidDetails(
                                      uid,
                                    );
                                    return ScrollableDialog(
                                      head: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Text(
                                              "支払った金額詳細 $profileName",
                                              maxLines: 1,
                                            ),
                                          ),
                                          Divider(color: Colors.cyan),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Table(
                                              border: TableBorder.all(
                                                color: Colors.grey,
                                              ), // 枠線を付けたい場合
                                              columnWidths: const {
                                                /* 票の横幅を調整 */
                                                0: FlexColumnWidth(1),
                                                1: FlexColumnWidth(1),
                                              },
                                              children:
                                                  paidList.map((data) {
                                                    return TableRow(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            data.expenseItem,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            "${data.paidAmount.round()}円",
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              onReimbursedTap: () {
                                /* 支払ってもらったリスト表示する */
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    final reimbursedList = viewModel
                                        .buildReimbursedDetails(uid);
                                    return ScrollableDialog(
                                      head: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Text(
                                              "かかった金額詳細 $profileName",
                                            ),
                                          ),
                                          Divider(color: Colors.cyan),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Table(
                                              border: TableBorder.all(
                                                color: Colors.grey,
                                              ), // 枠線を付けたい場合
                                              columnWidths: const {
                                                0: FlexColumnWidth(1),
                                                1: FlexColumnWidth(1),
                                              },
                                              children:
                                                  reimbursedList.map((data) {
                                                    return TableRow(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            data.expenseItem,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            "${data.owedAmount.toStringAsFixed(2)}円",
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }),
                        ],
                      ),
                  ],
        ),
      ),
    );
    ;
  }
}

TableRow buildBalancesRow({
  required String name,
  required double paidSum,
  required double reimbursedSum,
  required double netTotal,
  required bool roundDouble,
  VoidCallback? onPaidTap,
  VoidCallback? onReimbursedTap,
}) {
  return FourRowTableRow(
    first: Text(name),
    second: GestureDetector(
      onTap: onPaidTap,
      child: Text(
        roundDouble ? paidSum.round().toString() : paidSum.toStringAsFixed(2),
        style: TextStyle(
          color: onPaidTap != null ? Colors.cyanAccent : null,
          decoration: onPaidTap != null ? TextDecoration.underline : null,
        ),
      ),
    ),
    third: GestureDetector(
      onTap: onReimbursedTap,
      child: Text(
        roundDouble
            ? reimbursedSum.round().toString()
            : reimbursedSum.toStringAsFixed(2),
        style: TextStyle(
          color: onReimbursedTap != null ? Colors.cyanAccent : null,
          decoration: onReimbursedTap != null ? TextDecoration.underline : null,
        ),
      ),
    ),
    fourth: Text(
      roundDouble ? netTotal.round().toString() : netTotal.toStringAsFixed(2),
    ),
  );
}

TableRow FourRowTableRow({
  required Widget first,
  required Widget second,
  required Widget third,
  required Widget fourth,
}) {
  const double pad = 8;
  return TableRow(
    children: [
      Padding(padding: EdgeInsets.all(pad), child: first),
      Padding(padding: EdgeInsets.all(pad), child: second),
      Padding(padding: EdgeInsets.all(pad), child: third),
      Padding(padding: EdgeInsets.all(pad), child: fourth),
    ],
  );
}
