import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/components/CircleIconButton.dart';
import 'package:my_travel_app/data/model/itinerary_section/itinerary_section.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../../components/BasicText.dart';
import '../../../../../components/ValidatedSwitch.dart';
import '../../../../../constants.dart';
import 'itinerary_section_display.dart';

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
                        padding: const EdgeInsets.all(8.0),
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
                                final ret = await viewModel.switchEditModePreCheckWithNotify(newVal);
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
                              },
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child:
                          viewModel.editMode
                              ? Column(
                                children: [
                                  Expanded(
                                    child: ReorderableListView(
                                      onReorder: viewModel.reorderSection,
                                      buildDefaultDragHandles: false,
                                      /*  */
                                      children:
                                          viewModel.editingItinerarySections.asMap().entries.map((entry) {
                                            /* indexを使いたいのでわざわざMapにする */
                                            final index = entry.key;
                                            final section = entry.value;
                                            return ListTile(
                                              key: ValueKey(section.id),
                                              title: Slidable(
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
                                                    Expanded(child: Text("${section.id}")),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                  CircleIconButton(
                                    icon: Icons.add,
                                    onPressed: () async {
                                      final selectedSection = await showModalBottomSheet<ItinerarySection>(
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
                                                          () => context.pop(ItinerarySection.emptyMarkdown()),
                                                    ),
                                                    ListTile(
                                                      leading: Icon(Icons.table_chart),
                                                      title: Text('テーブル'),
                                                      onTap: () => context.pop(ItinerarySection.emptyTable()),
                                                    ),
                                                    ListTile(
                                                      leading: Icon(Icons.space_bar),
                                                      title: Text('空白行'),
                                                      onTap: () => context.pop(ItinerarySection.emptySpace()),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                      if (selectedSection != null) {
                                        viewModel.addSection(selectedSection);
                                      }
                                    },
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
