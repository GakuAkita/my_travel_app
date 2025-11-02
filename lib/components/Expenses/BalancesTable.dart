import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/BalanceInfo.dart';
import 'package:my_travel_app/CommonClass/ExpenseInfo.dart';
import 'package:my_travel_app/Store/ExpenseStore.dart';
import 'package:my_travel_app/components/ScrollableDialog.dart';
import 'package:provider/provider.dart';

import '../../CommonClass/TravelerBasic.dart';

class BalancesTable extends StatelessWidget {
  final Map<String, BalancesInfo> balances;
  final Map<String, TravelerBasic>
  participants; /* ResultScreenの引数として渡されている、、 */
  BalancesTable({
    required this.balances,
    required this.participants,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    /* ここでstore使っちゃえばいいか。 */
    final expenseStore = context.watch<ExpenseStore>();
    final personalPaidListsResult = expenseStore.createExpensePaidLists();
    final personalCostDetailsResult = expenseStore.calcEachPersonalDetails();
    return Table(
      children: [
        FourRowTableRow(
          first: Text("名前"),
          second: Text("払った金額(計)"),
          third: Text("かかった金額(計)"),
          fourth: Text("受け取る金額(負の場合は払う)"),
        ),
        ...balances.entries.map((entry) {
          final uid = entry.key;
          final name = TravelerBasic.getProfileNameFromUid(uid, participants);
          return buildBalancesRow(
            name: name,
            paidSum: entry.value.paidSum,
            reimbursedSum: entry.value.reimbursedSum,
            netTotal: entry.value.netTotal,
            roundDouble: true,
            onPaidTap: () {
              print("Paid Tapped. Name=${name}");
              if (personalPaidListsResult.isSuccess) {
                final paidList = personalPaidListsResult.data![uid];
                showDialog(
                  context: context,
                  builder: (context) {
                    return ScrollableDialog(
                      head: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3),
                            child: Text("支払った金額詳細 $name"),
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
                                  paidList!.map((data) {
                                    return TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(data.expenseItem),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${data.paidAmount.round()}円",
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                            ),
                            Text(
                              "合計:${ExpensePaidDetail.sumPaidDetailList(paidList).round()}",
                            ), //スクリーンに表示された金額と計算値が合わない可能性もある。
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                /* スナックバーでエラーが出ていることを伝えたい */
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "エラー：${personalPaidListsResult.error?.errorMessage}",
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            onReimbursedTap: () {
              print("Reimbursed Tapped. Name=${name}");
              if (personalCostDetailsResult.isSuccess) {
                final costList = personalCostDetailsResult.data![uid];
                showDialog(
                  context: context,
                  builder: (context) {
                    return ScrollableDialog(
                      head: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3),
                            child: Text("かかった金額詳細 $name"),
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
                                  costList!.map((data) {
                                    return TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(data.expenseItem),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${data.amountPerPerson.toStringAsFixed(2)}円",
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                            ),
                            Text(
                              "合計：${ExpensePersonalDetail.sumPersonalDetailList(costList).round()}",
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                /* スナックバーを出したい、、 */
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "エラー:${personalCostDetailsResult.error?.errorMessage}",
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          );
        }),
      ],
    );
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
