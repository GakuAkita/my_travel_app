import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/ExpenseInfo.dart';
import 'package:my_travel_app/CommonClass/ItineraryDefaultTable.dart';
import 'package:my_travel_app/Store/ItineraryStore.dart';
import 'package:my_travel_app/components/TopAppBar.dart';
import 'package:my_travel_app/constants.dart';
import 'package:provider/provider.dart';

class EstimatedExpenseScreen extends StatefulWidget {
  static const String id = "estimated_expense_screen";

  const EstimatedExpenseScreen({super.key});

  @override
  State<EstimatedExpenseScreen> createState() => _EstimatedExpenseScreenState();
}

class _EstimatedExpenseScreenState extends State<EstimatedExpenseScreen> {
  final List<EstimatedExpenseInfo> estimatedExpenseList = [];

  double estimatedExpense = 0.0;

  void _createBasicEstimatedList() {
    final itineraryStore = context.read<ItineraryStore>();
    final tables =
        itineraryStore
            .getData()
            .where((s) => s.type == ItinerarySectionType.defaultTable)
            .toList();

    /* 一番右の列で"****円/○人を正規表現で取得する */
    final expenseReg = RegExp(r'(\d+)円/(\d+)?人');

    for (final table in tables) {
      final tableData = table.tableData;
      if (tableData != null) {
        for (final row in tableData.tableCells) {
          final expenseMatches = expenseReg.allMatches(row[2]);
          for (final match in expenseMatches) {
            print("${match.group(0)} | ${match.group(1)} | ${match.group(2)}");
            final amount = double.parse(match.group(1)!);
            final peopleCnt = int.parse(match.group(2) ?? "1");

            /* expenseStoreと中身検知して逆算するのはありかもな。 */
            final estimated = EstimatedExpenseInfo(
              id: "",
              expenseItem: "",
              amount: amount,
              reimbursedByCnt: peopleCnt,
            );

            estimatedExpenseList.add(estimated);
          }
        }
      }
    }
    setState(() {});
  }

  void _sumEstimatedExpenseList() {
    final itineraryStore = context.read<ItineraryStore>();
    final tables =
        itineraryStore
            .getData()
            .where((s) => s.type == ItinerarySectionType.defaultTable)
            .toList();

    estimatedExpense = 0;

    for (final est in estimatedExpenseList) {
      //print(est.amount);
      estimatedExpense += (est.amount / est.reimbursedByCnt);
    }

    /* 昼ご飯と夕食をそれぞれ2000円,3000円で計算 */
    //print("テーブルの数(=工程の数) = ${tables.length}");
    final lunchTotal = 2000 * tables.length;
    estimatedExpense += lunchTotal;

    final dinnerTotal = 3000 * tables.length;
    estimatedExpense += dinnerTotal;

    setState(() {});
  }

  /* 費用概算は工程表を元に計算してく */
  @override
  void initState() {
    super.initState();
    _createBasicEstimatedList();
    _sumEstimatedExpenseList();
  }

  @override
  Widget build(BuildContext context) {
    final itineraryStore = Provider.of<ItineraryStore>(context);

    final tables =
        itineraryStore
            .getData()
            .where((s) => s.type == ItinerarySectionType.defaultTable)
            .toList();

    return Scaffold(
      appBar: TopAppBar(title: "費用概算(作成中)", automaticallyImplyLeading: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //...tables.map((table) => TableDataShown(table: table.tableData)),
              ...estimatedExpenseList.map(
                (estimated) => Text(
                  "${estimated.amount.toInt()}円 / ${estimated.reimbursedByCnt}人",
                ),
              ),
              Text("============================="),
              Text("予想合計=${estimatedExpense}"),
            ],
          ),
        ),
      ),
    );
  }
}

class TableDataShown extends StatelessWidget {
  final ItineraryDefaultTable? table;

  const TableDataShown({required this.table, super.key});

  @override
  Widget build(BuildContext context) {
    return table != null
        ? Column(
          children: [
            ...table!.tableCells.map(
              (row) => Row(
                children: [
                  Flexible(fit: FlexFit.tight, child: Text("${row[1]}")),
                  Flexible(fit: FlexFit.tight, child: Text("${row[2]}")),
                ],
              ),
            ),
            Text("------------------------"),
          ],
        )
        : Row(children: [Text("null")]);
  }
}
