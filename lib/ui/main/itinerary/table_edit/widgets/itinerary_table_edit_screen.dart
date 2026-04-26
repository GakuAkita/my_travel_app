import 'package:flutter/material.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/data/model/itinerary_section/itinerary_section.dart';
import 'package:my_travel_app/data/model/itinerary_table/itinerary_table.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';
import 'package:my_travel_app/ui/main/itinerary/table_edit/editing_itinerary_table.dart';
import 'package:provider/provider.dart';

import '../../../../../components/BasicText.dart';

class ItineraryTableEditScreen extends StatefulWidget {
  final String sectionId;

  const ItineraryTableEditScreen({required this.sectionId, super.key});

  @override
  State<ItineraryTableEditScreen> createState() => _ItineraryTableEditScreenState();
}

class _ItineraryTableEditScreenState extends State<ItineraryTableEditScreen> {
  EditingItineraryTable _editingTable = EditingItineraryTable(header: [], tableCells: [], flexes: []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final viewModel = context.read<ItineraryViewModel>();
    final table = viewModel.getTableById(widget.sectionId);
    if (table == null) {
      return;
    }
    setState(() {
      _editingTable = table.tableData.toEditing();
    });
  }

  @override
  void dispose() {
    /* 画面から離れるときにViewModelに保存する */

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ItineraryViewModel>();
    final section = viewModel.getSectionById(widget.sectionId) as TableSection;
    final tableData = section.tableData;
    final header = tableData.header;
    final flexes = tableData.flexes;
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 25),
              ...header.map((head) {
                return Expanded(
                  flex: flexes[header.indexOf(head)],
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.primary),
                    ),
                    child: Center(child: BasicText(text: head)),
                  ),
                );
              }),
            ],
          ),
          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              shrinkWrap: true,
              itemCount: tableData.tableCells.length,
              onReorder: (oldIndex, newIndex) {},
              itemBuilder: (context, rowIndex) {
                return Text("aa");
              },
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsetsGeometry.symmetric(vertical: 20),
                child: RoundedButton(
                  title: "行を追加",
                  onPressed: () {
                    /* 固定列を追加 */
                    viewModel.addTableNewRow(id: widget.sectionId);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
