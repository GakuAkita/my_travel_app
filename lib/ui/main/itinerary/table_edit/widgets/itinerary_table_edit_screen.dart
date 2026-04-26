import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_travel_app/components/MultilineTextField.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
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
    final viewModel = context.read<ItineraryViewModel>();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 45),
              ..._editingTable.header.map((head) {
                return Expanded(
                  flex: _editingTable.flexes[_editingTable.header.indexOf(head)],
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
              itemCount: _editingTable.tableCells.length,
              onReorder: (oldIndex, newIndex) {},
              itemBuilder: (context, rowIndex) {
                final row = _editingTable.tableCells[rowIndex];
                return Slidable(
                  key: ValueKey('row_$rowIndex'),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          setState(() {
                            _editingTable.tableCells.removeAt(rowIndex);
                          });
                        },
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                        icon: Icons.delete,
                        label: "この行を削除",
                      ),
                    ],
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 45),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Listener(
                          onPointerDown: (_) {
                            /* iconに触れた瞬間にフォーカスを外す */
                            FocusScope.of(context).unfocus();
                          },
                          child: ReorderableDragStartListener(
                            index: rowIndex,
                            child: Icon(Icons.drag_handle, size: 45),
                          ),
                        ),
                        ...row.asMap().entries.map((colEntry) {
                          final colIndex = colEntry.key;
                          final cell = colEntry.value;
                          return Expanded(
                            flex: _editingTable.flexes[colIndex],
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).colorScheme.primary),
                              ),
                              child: MultilineTextField(
                                hintText: "",
                                initialText: cell,
                                onChanged: (val) {},
                                maxLines: 1,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
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
                    final newRow = List.filled(_editingTable.header.length, "");
                    /* 固定列を追加 */
                    setState(() {
                      _editingTable.tableCells.add(newRow);
                    });
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
