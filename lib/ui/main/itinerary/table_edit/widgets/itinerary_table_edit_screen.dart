import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_travel_app/components/MultilineTextField.dart';
import 'package:my_travel_app/data/model/itinerary_table/itinerary_table.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';
import 'package:my_travel_app/ui/main/itinerary/table_edit/editing_itinerary_table.dart';

/// @todo これ戻り値みたいにしてItinerary Mainで編集後のデータを受け取ってあっちで保存した法が良い。
class ItineraryTableEditScreen extends StatefulWidget {
  final String sectionId;
  final ItineraryViewModel viewModel;

  const ItineraryTableEditScreen({required this.sectionId, required this.viewModel, super.key});

  @override
  State<ItineraryTableEditScreen> createState() => _ItineraryTableEditScreenState();
}

class _ItineraryTableEditScreenState extends State<ItineraryTableEditScreen> {
  EditingItineraryTable _editingTable = EditingItineraryTable(header: [], tableCells: [], flexes: []);
  late ItineraryViewModel _viewModel;

  /* dispose時に保存するとき、この参照先を保持しておく必要がある */

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _viewModel = widget.viewModel;
    final table = _viewModel.getTableById(widget.sectionId);
    if (table == null) {
      return;
    }
    setState(() {
      _editingTable = table.tableData.toEditing();
    });
  }

  @override
  void dispose() {
    final table = _editingTable.toModel();

    /* 画面から離れるときにViewModelに保存する */
    final ret = _viewModel.updateTable(id: widget.sectionId, table: table, notify: false);
    if (ret == 0) {
      print("Table was updated");
    }
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lineColor = colorScheme.primary.withValues(alpha: 0.3);
    const double handleWidth = 40;

    return Scaffold(
      appBar: TopAppBar(title: "テーブル編集", automaticallyImplyLeading: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              "左にスワイプで行を削除、ハンドルをドラッグで並び替え",
              style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 8),
          /* ヘッダー行 */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const SizedBox(width: handleWidth),
                for (int i = 0; i < _editingTable.header.length; i++)
                  Expanded(
                    flex: _editingTable.flexes[i],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.15),
                        border: Border.all(color: lineColor),
                      ),
                      child: Text(
                        _editingTable.header[i],
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w700, color: colorScheme.primary),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              buildDefaultDragHandles: false,
              itemCount: _editingTable.tableCells.length,
              onReorder: (oldIndex, newIndex) {
                print("reorder called :${oldIndex} ${newIndex}");
                if (newIndex > oldIndex) {
                  /* 一個removeAtで消えるので一個ずれる？ */
                  newIndex -= 1;
                }
                print("Remove : index=${oldIndex}");
                final row = _editingTable.tableCells.removeAt(oldIndex);
                _editingTable.tableCells.insert(newIndex, row);
                print("Finished reordering");
                setState(() {});
              },
              footer: Padding(
                padding: const EdgeInsets.fromLTRB(handleWidth, 12, 0, 24),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                  icon: const Icon(Icons.add),
                  label: const Text("行を追加"),
                  onPressed: () {
                    final newRow = List.filled(_editingTable.header.length, "");
                    /* 固定列を追加 */
                    setState(() {
                      _editingTable.tableCells.add(newRow);
                    });
                  },
                ),
              ),
              itemBuilder: (context, rowIndex) {
                final row = _editingTable.tableCells[rowIndex];
                return Slidable(
                  // key: ValueKey('row_$rowIndex'),
                  key: ObjectKey(row),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.3,
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          setState(() {
                            _editingTable.tableCells.removeAt(rowIndex);
                          });
                        },
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        icon: Icons.delete_outline,
                        label: "この行を削除",
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Listener(
                          onPointerDown: (_) {
                            /* iconに触れた瞬間にフォーカスを外す */
                            FocusScope.of(context).unfocus();
                          },
                          child: ReorderableDragStartListener(
                            index: rowIndex,
                            child: SizedBox(
                              width: handleWidth,
                              child: Icon(Icons.drag_indicator, color: colorScheme.onSurfaceVariant),
                            ),
                          ),
                        ),
                        ...row.asMap().entries.map((colEntry) {
                          final colIndex = colEntry.key;
                          final cell = colEntry.value;
                          return Expanded(
                            flex: _editingTable.flexes[colIndex],
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: lineColor)),
                              child: MultilineTextField(
                                hintText: "",
                                initialText: cell,
                                border: InputBorder.none,
                                onChanged: (val) {
                                  _editingTable.tableCells[rowIndex][colIndex] = val;
                                },
                                minLines: 1,
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
        ],
      ),
    );
  }
}
