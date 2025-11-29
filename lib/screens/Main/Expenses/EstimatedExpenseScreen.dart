import 'package:flutter/material.dart';
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
  /* 費用概算は工程表を元に計算してく */
  @override
  void initState() {
    super.initState();

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
          }
        }
      }
    }
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
              ...tables.map((table) => TableDataShown(table: table.tableData)),
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
