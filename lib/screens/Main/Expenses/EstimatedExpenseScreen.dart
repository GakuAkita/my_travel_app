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
  Widget build(BuildContext context) {
    final itineraryStore = Provider.of<ItineraryStore>(context);

    final tables =
        itineraryStore
            .getData()
            .where((s) => s.type == ItinerarySectionType.defaultTable)
            .toList();

    return Scaffold(
      appBar: TopAppBar(title: "費用概算(作成中)", automaticallyImplyLeading: true),
      body: Center(
        child: Column(
          children: [
            ...tables.map(
              (table) => Text("${table.tableData?.tableCells[2]}\n-----"),
            ),
          ],
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
        ? Row(
          children: table!.tableCells.map((row) {
            return Text("${row}");
          }),
        )
        : Row();
  }
}
