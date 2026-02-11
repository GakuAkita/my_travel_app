import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/Services/FirebaseDatabaseService.dart';
import 'package:my_travel_app/components/BasicText.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/components/TopAppBar.dart';

class DeleteGroupScreen extends StatefulWidget {
  static const String id = "delete_group_screen";

  const DeleteGroupScreen({super.key});

  @override
  State<DeleteGroupScreen> createState() => _DeleteGroupScreenState();
}

class _DeleteGroupScreenState extends State<DeleteGroupScreen> {
  bool _isLoading = true;
  List<String> groupKeys = [];
  String? _selectedGroupKey;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        _isLoading = true;
        final groupKeysMap = await FirebaseDatabaseService.getGroupKeys();
        if (groupKeysMap == null) {
          print("Unable to get groupKeys");
          return;
        }

        for (String key in groupKeysMap.keys) {
          groupKeys.add(key);
        }
        print("End of microTask");
      } catch (e) {
        print("$e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(title: "グループ削除", automaticallyImplyLeading: true),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child:
            !_isLoading && groupKeys.isNotEmpty
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...groupKeys.map((groupKey) {
                      return RadioListTile(
                        title: BasicText(text: groupKey),
                        value: groupKey,
                        groupValue: _selectedGroupKey,
                        onChanged: (val) {
                          setState(() {
                            if (val != null) {
                              _selectedGroupKey = val;
                            }
                          });
                        },
                      );
                    }),
                    if (_selectedGroupKey != null)
                      RoundedButton(
                        title: "グループ削除",
                        onPressed: () async {
                          /**
                   * groupsKeyから消す、
                   * membersを取って、
                   * shown_travelでgroupIdがあるところは消す
                   * joinedGroupsから消す。
                   */
                          final retMembers =
                              await FirebaseDatabaseService.getGroupMembers(
                                _selectedGroupKey!,
                              );
                          if (!retMembers.isSuccess) {
                            print("Failed to get group members");
                            return;
                          } else if (retMembers.data == null) {
                            print("Group members are null");
                            /* shownTravelを調べて消す必要ない */
                            return;
                          } else {
                            /* Do Nothing */
                          }

                          final members = retMembers.data;

                          /* グループのmembersが取れた。 */
                          /* 各travelのshownTravelを消していいく。 */
                          for (String uid in members!.keys.toList()) {
                            print("group member:${members[uid]?.email}");
                            //joinedGroupから消す
                            await FirebaseDatabaseService.singleUserJoinedGroupRef(
                              uid,
                            ).child(_selectedGroupKey!).remove();

                            /* shownTravelを確認して、このgroupIdだったら消す */
                            final st =
                                await FirebaseDatabaseService.getSingleUserShownTravel(
                                  uid,
                                );
                            if (st == null) {
                              //nullだったら設定されてない可能性が高いのでスキップ
                              print("No need to modify user's shownTravel.");
                            } else if (st.groupId == _selectedGroupKey) {
                              await FirebaseDatabaseService.singleUserShownTravelRef(
                                uid,
                              ).remove();
                            }
                          }
                          /* groupKeysから消して、さらにgroup配下をすべて消す */
                          await FirebaseDatabaseService.groupKeysRef
                              .child(_selectedGroupKey!)
                              .remove();
                          await FirebaseDatabaseService.singleGroupRef(
                            _selectedGroupKey!,
                          ).remove();

                          Navigator.pop(context);
                        },
                      ),
                  ],
                )
                : BasicText(text: "グループがおそらく何も存在しない"),
      ),
    );
  }
}
