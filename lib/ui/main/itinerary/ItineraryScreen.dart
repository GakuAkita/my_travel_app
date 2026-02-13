import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/Store/ItineraryStore.dart';
import 'package:my_travel_app/components/CircleIconButton.dart';
import 'package:my_travel_app/components/Itinerary/ItinerarySectionDsiplay.dart';
import 'package:my_travel_app/components/SimpleTextButton.dart';
import 'package:my_travel_app/constants.dart';
import 'package:provider/provider.dart';

import '../../../Store/UserStore.dart';
import '../../../components/BasicText.dart';
import '../../../components/Itinerary/ItineraryMarkdownSectionEdit.dart';
import '../../../components/ValidatedSwitch.dart';
import 'ItineraryTableEditScreen.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  static const String id = "itinerary_screen";

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
  }

  /* これはあくまで秋田仕様のしおりだから柔軟に対応できるようにしたいな,,, */
  @override
  Widget build(BuildContext context) {
    final userStore = context.read<UserStore>();
    final itineraryStore = context.watch<ItineraryStore>();
    /**
     * 戻り値がそのままスイッチの値になる
     */
    Future<bool> confirmChangeSwitch(bool newValue) async {
      print("confirmChangeSwitch called");
      if (newValue) {
        /**
         * TrueからFalseにするとき
         * 編集を開始する
         */
        /* setEditMode内でリモートとのやりとりをする。onしてよいかの制御も。 */
      } else {
        /**
         * FalseからTrueにするとき
         * スイッチをオフからオンにするとき
         */
        final bool? confirm = await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder:
              (context) => AlertDialog(
                title: Text("保存しますか？"),
                content: Text(
                  "データを保存してから切り替えますか？\n編集を続けたい場合はポップアップ外をタップしてください",
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("保存せずに閉じる"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("保存する"),
                      ),
                    ],
                  ),
                ],
              ),
        );
        if (confirm == null) {
          /* 変化させない! */
          return !newValue;
        } else {
          /* @TODO userStoreのshownTravelでなくてitineraryのshownTravelで設定する */
          /* 現在のgroupIdとtravelId */
          if (userStore.shownTravelBasic == null ||
              userStore.shownTravelBasic!.groupId == null ||
              userStore.shownTravelBasic!.travelId == null) {
            print(
              "ここに来ることはまずない。\ngroupId:${userStore.shownTravelBasic?.groupId} traveId:${userStore.shownTravelBasic?.travelId}",
            );
            return !newValue;
          }
          final travelBasic = userStore.shownTravelBasic!;
          final groupId = userStore.shownTravelBasic!.groupId!;
          final travelId = userStore.shownTravelBasic!.travelId!;
          /* itineraryデータを保存してnewValueに設定 */
          if (confirm) {
            /* 編集したitineraryを保存する。ローカルの編集は終わっているのでバックグラウンドで走らせる(awaitしない) */
            /* これ失敗したときにどうしようもないな、、、 */
            itineraryStore.saveData(groupId, travelId);
          } else {
            /* 編集したけど保存しないで閉じる */
            /* リモートから読み直す */
            itineraryStore.loadItineraryDataWithNotify(travelBasic);
          }
          return newValue;
        }
      }
      return newValue;
    }

    /**
     * itineraryStoreには必ずsetしてもらいたい。
     */
    Future<bool> onSwitchTapped(bool newValue) async {
      print("onSwitchTapped called");
      final desiredSwitchState = await confirmChangeSwitch(newValue);

      /* ユーザーはスイッチの状態を変えたいということなので、変えに行く */
      final setModeRet = await itineraryStore.setEditMode(desiredSwitchState);
      if (!setModeRet.isSuccess) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(setModeRet.error?.errorMessage ?? "Unknown error"),
            ),
          );
        }
        return !desiredSwitchState; /* newValueでも良い */
      }

      print("onSwitchTapped called desiredSwitchState:$desiredSwitchState");

      return desiredSwitchState;
    }

    return LoadingOverlay(
      isLoading: itineraryStore.itineraryState.isLoading,
      child:
          itineraryStore.shownTravelBasic != null &&
                  !itineraryStore.itineraryState.isLoading
              ? Column(
                children: [
                  if (userStore.userRole == UserRole.admin ||
                      userStore.isGManager)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BasicText(text: "プランナーモード"),
                          SizedBox(width: 10),
                          ValidatedSwitch(
                            initialStatus: itineraryStore.editMode,
                            onWillChange: onSwitchTapped,
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    // 👈 スクロール対応のために Column の中を Expanded
                    child:
                        !itineraryStore.editMode
                            ? RefreshIndicator(
                              onRefresh: () async {
                                print("refreshing... by pulling down");
                                /* awaitいれないといつまでローディングしているかわからない */
                                await itineraryStore
                                    .loadItineraryDataWithNotify(
                                      itineraryStore.shownTravelBasic,
                                      isStateNotify: false,
                                    );
                              },
                              child: SingleChildScrollView(
                                physics:
                                    AlwaysScrollableScrollPhysics(), //これを入れないと、内容が少ないときに引っ張れない
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    left: 10,
                                    right: 10,
                                  ),
                                  child:
                                      itineraryStore.getData().isNotEmpty
                                          ? Column(
                                            /* こっちは表示用 */
                                            children: [
                                              ...itineraryStore.getData().map((
                                                section,
                                              ) {
                                                return ItinerarySectionDisplay(
                                                  itiSection: section,
                                                );
                                              }),
                                            ],
                                          )
                                          : BasicText(
                                            text: "しおりが作成されていません",
                                          ), //itineraryが何もない,
                                ),
                              ),
                            )
                            : ListView(
                              /* こっちは編集モードのレイアウト */
                              children: [
                                BasicText(text: "プランナーモードをOFFにしたときに保存されます。"),
                                ReorderableListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  // スクロールを外に任せる
                                  onReorder: itineraryStore.reorderSection,
                                  buildDefaultDragHandles: false,
                                  children: [
                                    ...itineraryStore.getData().map((section) {
                                      final index = itineraryStore
                                          .getData()
                                          .indexOf(section);
                                      return Slidable(
                                        key: ValueKey(section),
                                        endActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (_) {
                                                itineraryStore.removeSection(
                                                  index,
                                                );
                                              },
                                              backgroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.error,
                                              foregroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onError,
                                              icon: Icons.delete,
                                              label: "delete",
                                            ),
                                          ],
                                        ),
                                        child:
                                            section.type ==
                                                    ItinerarySectionType
                                                        .markdown
                                                ? Row(
                                                  children: [
                                                    Listener(
                                                      onPointerDown: (_) {
                                                        FocusScope.of(
                                                          context,
                                                        ).unfocus();
                                                      },
                                                      child:
                                                          itineraryStore
                                                                      .getData()
                                                                      .length !=
                                                                  1
                                                              ? ReorderableDragStartListener(
                                                                index: index,
                                                                child: Icon(
                                                                  Icons
                                                                      .drag_handle,
                                                                  size: 50,
                                                                ),
                                                              )
                                                              : SizedBox(),
                                                    ),
                                                    Expanded(
                                                      flex: 6,
                                                      child:
                                                          ItineraryMarkdownSectionEdit(
                                                            index: index,
                                                            onChanged:
                                                                (
                                                                  title,
                                                                  content,
                                                                ) {},
                                                          ),
                                                    ),
                                                  ],
                                                )
                                                : section.type ==
                                                    ItinerarySectionType
                                                        .defaultTable
                                                ? Row(
                                                  children: [
                                                    if (itineraryStore
                                                            .getData()
                                                            .length >=
                                                        1)
                                                      ReorderableDragStartListener(
                                                        child: Icon(
                                                          Icons.drag_handle,
                                                          size: 70,
                                                        ),
                                                        index: index,
                                                      ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              10,
                                                            ),
                                                        child: SimpleTextButton(
                                                          onPressed: () {
                                                            Navigator.pushNamed(
                                                              context,
                                                              ItineraryTableEditScreen
                                                                  .id,
                                                              arguments: index,
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color:
                                                                    Colors
                                                                        .white38,
                                                              ),
                                                            ),
                                                            height: 100,
                                                            child: Center(
                                                              child: BasicText(
                                                                text:
                                                                    "テーブル\nタップして編集",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                : Row(
                                                  children: [
                                                    if (itineraryStore
                                                            .getData()
                                                            .length >=
                                                        1)
                                                      ReorderableDragStartListener(
                                                        child: Icon(
                                                          Icons.drag_handle,
                                                          size: 70,
                                                        ),
                                                        index: index,
                                                      ),
                                                    Expanded(
                                                      child: Container(
                                                        height:
                                                            20, // 高さを指定（中央寄せしやすく）
                                                        alignment:
                                                            Alignment
                                                                .center, // ← これで中央寄せ
                                                        child: Text("空白スペース"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                      );
                                    }),
                                  ],
                                ),
                                SizedBox(height: 20),
                                CircleIconButton(
                                  icon: Icons.add,
                                  onPressed: () async {
                                    final selectedType = await showModalBottomSheet<
                                      String
                                    >(
                                      context: context,
                                      isScrollControlled: true, // ← これ重要！
                                      backgroundColor: Colors.transparent,
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
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).canvasColor,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                      top: Radius.circular(20),
                                                    ),
                                              ),
                                              child: ListView(
                                                controller: scrollController,
                                                children: [
                                                  ListTile(
                                                    leading: Icon(
                                                      Icons.text_fields,
                                                    ),
                                                    title: Text('通常Markdown'),
                                                    onTap:
                                                        () => Navigator.pop(
                                                          context,
                                                          ItinerarySectionType
                                                              .markdown,
                                                        ),
                                                  ),
                                                  ListTile(
                                                    leading: Icon(
                                                      Icons.table_chart,
                                                    ),
                                                    title: Text('テーブル'),
                                                    onTap:
                                                        () => Navigator.pop(
                                                          context,
                                                          ItinerarySectionType
                                                              .defaultTable,
                                                        ),
                                                  ),
                                                  ListTile(
                                                    leading: Icon(
                                                      Icons.space_bar,
                                                    ),
                                                    title: Text('空白行'),
                                                    onTap:
                                                        () => Navigator.pop(
                                                          context,
                                                          ItinerarySectionType
                                                              .space,
                                                        ),
                                                  ),
                                                  // 追加で他のセクション種類があるならここにListTileで追加してOK
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );

                                    if (selectedType != null) {
                                      itineraryStore.addSection(selectedType);
                                      print(
                                        "Section added!! selectedType:${selectedType}",
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                  ),
                ],
              )
              : itineraryStore.itineraryState.isLoading
              ? Center(child: Text("loading..."))
              : Center(
                child: BasicText(text: "Settingsから表示旅行を設定してください"),
              ) /* shownTravelがnullになっている */,
    );
  }
}
