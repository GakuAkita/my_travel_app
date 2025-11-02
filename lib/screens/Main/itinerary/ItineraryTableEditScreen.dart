import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_travel_app/Store/ItineraryStore.dart';
import 'package:my_travel_app/components/BasicText.dart';
import 'package:my_travel_app/components/MultilineTextField.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/components/TopAppBar.dart';
import 'package:provider/provider.dart';

class ItineraryTableEditScreen extends StatefulWidget {
  static const String id = "itinerary_table_edit_screen";
  final int index;
  const ItineraryTableEditScreen({required this.index, super.key});

  @override
  State<ItineraryTableEditScreen> createState() =>
      _ItineraryTableEditScreenState();
}

class _ItineraryTableEditScreenState extends State<ItineraryTableEditScreen> {
  @override
  Widget build(BuildContext context) {
    final itinerarySections = context.watch<ItineraryStore>();
    final section = itinerarySections.getData()[widget.index];
    final tableData = section.tableData!;
    final header = tableData.header;
    final tableCells = tableData.tableCells;
    final flexes = tableData.flexes;
    /**
     * typeがちゃんとtableになっているかチェックしたほうがいいかもな。
     */
    return Scaffold(
      appBar: TopAppBar(
        title: "テーブルを編集(section ${widget.index} )",
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 25),
                    ...header.map((head) {
                      return Expanded(
                        flex:
                            flexes[header.indexOf(
                              head,
                            )] /* 同じ要素が２つあったらどうなるんだろう？ */,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
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
                    itemCount: tableCells.length,
                    onReorder: (oldIndex, newIndex) {
                      FocusScope.of(context).unfocus();
                      itinerarySections.reorderTableRow(
                        widget.index,
                        oldIndex,
                        newIndex,
                      );
                    },
                    itemBuilder: (context, rowIndex) {
                      final row = tableCells[rowIndex];

                      return Slidable(
                        key: ValueKey('row_$rowIndex'),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) {
                                setState(() {
                                  itinerarySections.removeTableRow(
                                    widget.index,
                                    rowIndex,
                                  );
                                });
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'この行を削除',
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Listener(
                              onPointerDown: (_) {
                                //iconに触れた瞬間にフォーカスを外す
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
                                flex: flexes[colIndex],
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: MultilineTextField(
                                    hintText: "",
                                    initialText: cell,
                                    onChanged: (val) {
                                      tableCells[rowIndex][colIndex] = val;
                                    },
                                    minLines: 1,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BasicText(
                        text: "編集が終わったら前の画面に戻って(必要に応じて)保存してください",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: RoundedButton(
                        title: "行を追加",
                        onPressed: () {
                          /* tableCellsに追加 */
                          /**
                         *  @TODO 今のところ、3列固定で作っているが、将来的には列も追加できるようにする。
                         *  */
                          itinerarySections.addTableRow(widget.index);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
