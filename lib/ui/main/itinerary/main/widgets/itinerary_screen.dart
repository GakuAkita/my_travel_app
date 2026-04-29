import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../../components/BasicText.dart';
import '../../../../../components/CircleIconButton.dart';
import '../../../../../components/ValidatedSwitch.dart';
import '../../../../../constants.dart';
import '../../../../../data/model/itinerary_section/itinerary_section.dart';
import 'itinerary_section_display.dart';
import 'itinerary_section_edit.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final viewModel = context.read<ItineraryViewModel>();
    /* Adminなら常に編集モードを表示 */
    if (!viewModel.roleState.hasData || viewModel.roleState.hasError) {
      viewModel.fetchUserRole();
    } else {
      /* 再取得する必要はない */
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ItineraryViewModel>();
    return LoadingOverlay(
      isLoading: viewModel.isItineraryLoading,
      child: Column(
        children: [
          viewModel.isItineraryLoading
              ? Center(child: Text("Loading..."))
              : viewModel.travel == null
              ? Center(child: BasicText(text: "Settingsから表示旅行を設定してください"))
              : Expanded(
                child: Column(
                  children: [
                    if (viewModel.userRole == UserRole.admin)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BasicText(text: "プランナーモード"),
                            /* 編集モードと同義 */
                            SizedBox(width: 10),
                            ValidatedSwitch(
                              initialStatus: viewModel.editMode,
                              isEnabled: !viewModel.isEditLoading,
                              /* 複数連続タップ禁止 */
                              onWillChange: (newVal) async {
                                if (newVal) {
                                  /* offからonにするとき */
                                  final ret = await viewModel.switchEditModePreCheckWithNotify();
                                  if (ret.isSuccess) {
                                    viewModel.setEditMode(newVal);
                                    viewModel.copySectionsToBuffer();
                                    return newVal;
                                  } else {
                                    print("${ret.error?.errorMessage}");
                                    viewModel.setEditMode(!newVal);
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(ret.error?.errorMessage ?? "Unknown error")),
                                    );
                                    return !newVal; /* 変更せずの元の状態を保持 */
                                  }
                                } else {
                                  /* 保存するか */
                                  final bool? confirm = await showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder:
                                        (context) => AlertDialog(
                                          title: Text("保存しますか？"),
                                          content: Text("データを保存してから切り替えますか?\n編集を続けたい場合はポップアップ外をタップしてください"),
                                          actions: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () => context.pop(false),
                                                  child: Text("保存せずに閉じる"),
                                                ),
                                                TextButton(
                                                  onPressed: () => context.pop(true),
                                                  child: Text("保存する"),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                  );
                                  if (confirm == null) {
                                    print("switch EditMode Canceled");
                                    return !newVal;
                                  } else {
                                    if (confirm) {
                                      /* editingを転写し、データをリモートに上げる */
                                      final ret = await viewModel.saveItinerarySections();
                                      if (ret.isSuccess) {
                                        /* watchでItineraryStoreで自動で更新される。 */

                                        /* onEditを消しに行く */
                                      } else {
                                        /* スナックバーを出す */
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(ret.error?.errorMessage ?? "Unknown error")),
                                        );
                                        return !newVal;
                                      }
                                    } else {
                                      /* 保存せずに閉じるので、editingの内容はそのままにして捨てる */
                                      print("Switch to editMode off without saving itinerary");
                                    }
                                    viewModel.setEditMode(newVal);
                                    /* onEditを消す */
                                    return newVal;
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child:
                          viewModel.editMode
                              ? CustomScrollView(
                                slivers: [
                                  SliverReorderableList(
                                    itemCount: viewModel.editingItinerarySections.length,
                                    onReorder: viewModel.reorderSection,
                                    itemBuilder: (context, index) {
                                      final section = viewModel.editingItinerarySections[index];

                                      return Container(
                                        key: ValueKey(section.id),
                                        child: Slidable(
                                          endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (_) {
                                                  final ret = viewModel.removeSection(section.id);
                                                  if (ret < 0) {
                                                    /* 削除に失敗。ほとんどないけどね。 */
                                                  }
                                                },
                                                backgroundColor: Theme.of(context).colorScheme.error,
                                                foregroundColor: Theme.of(context).colorScheme.onError,
                                                icon: Icons.delete,
                                                label: "delete",
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              if (viewModel.editingItinerarySections.length >= 2)
                                                ReorderableDragStartListener(
                                                  child: Icon(Icons.drag_handle, size: 50),
                                                  index: index,
                                                ),
                                              Expanded(child: ItinerarySectionEdit(id: section.id)),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: CircleIconButton(
                                        icon: Icons.add,
                                        onPressed: () async {
                                          final selectedSection = await showModalBottomSheet<
                                            ItinerarySection
                                          >(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return DraggableScrollableSheet(
                                                initialChildSize: 0.5,
                                                // 最初の高さ（画面の50%）
                                                minChildSize: 0.2,
                                                maxChildSize: 0.9,
                                                // 最大で画面の90%まで引っ張れる
                                                expand: false,
                                                builder: (_, scrollController) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.surface,
                                                      borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(20),
                                                      ),
                                                    ),
                                                    child: ListView(
                                                      controller: scrollController,
                                                      children: [
                                                        ListTile(
                                                          leading: Icon(Icons.text_fields),
                                                          title: Text('通常Markdown'),
                                                          onTap:
                                                              () => context.pop(
                                                                ItinerarySection.emptyMarkdown(),
                                                              ),
                                                        ),
                                                        ListTile(
                                                          leading: Icon(Icons.table_chart),
                                                          title: Text('テーブル'),
                                                          onTap:
                                                              () =>
                                                                  context.pop(ItinerarySection.emptyTable()),
                                                        ),
                                                        ListTile(
                                                          leading: Icon(Icons.space_bar),
                                                          title: Text('空白行'),
                                                          onTap:
                                                              () =>
                                                                  context.pop(ItinerarySection.emptySpace()),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                          if (selectedSection != null) {
                                            print("selectedSection = ${selectedSection.runtimeType}");
                                            viewModel.addSection(selectedSection);
                                          } else {
                                            print("add section canceled");
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : RefreshIndicator(
                                /* 表示用 */
                                onRefresh: () async {},
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                    child: Column(
                                      children: [
                                        if (viewModel.itinerarySections.isEmpty)
                                          Center(child: BasicText(text: "しおりが作られていません"))
                                        else
                                          ...viewModel.itinerarySections.map(
                                            (sec) => ItinerarySectionDisplay(itiSection: sec),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

Widget buildDragTile(ItinerarySection section) {
  return Container(
    height: 60,
    padding: EdgeInsets.all(12),
    child: Row(children: [Icon(Icons.drag_handle), SizedBox(width: 8), Text("${section.runtimeType}")]),
  );
}
