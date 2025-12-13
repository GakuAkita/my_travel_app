import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/CommonClass/ShownTravelBasic.dart';
import 'package:my_travel_app/Services/FirebaseDatabaseService.dart';
import 'package:my_travel_app/Store/ExpenseStore.dart';
import 'package:my_travel_app/Store/ItineraryStore.dart';
import 'package:my_travel_app/Store/UserStore.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/components/TopAppBar.dart';
import 'package:my_travel_app/constants.dart';
import 'package:provider/provider.dart';

import '../../../CommonClass/TravelInfo.dart';
import '../../../CommonClass/TravelerInfo.dart';
import '../../../components/BasicTextField.dart';

//@FIXME　ゴリクソ汚いからまあ必要になったら修正してくれ。めっちゃ無駄なことをしている気がする。

class TravelManageScreen extends StatefulWidget {
  static const String id = "travel_manage_screen";
  final String userRole;

  TravelManageScreen({required this.userRole, super.key});

  @override
  State<TravelManageScreen> createState() => _TravelManageScreenState();
}

class _TravelManageScreenState extends State<TravelManageScreen> {
  String _newTravelName = "";
  String? _selectedGroupForCreation; //新規作成のときのselectedGroup

  String? _selectedTravelId;
  String? _selectedGroupId;

  bool _joinedGroupEmptyFlag = false;

  bool _isLoading = true;

  Map<dynamic, dynamic>? _groupKeys = null;
  List<GroupTravels> _joinedGroupTravel = [];

  /* RealtimeDatabaseにあるshown_travelの情報を取ってきて、それをベースにチェックボックスを作りたい。 */
  String? _adminGroupId;
  List<TravelerInfo> _possibleTravelers = [];

  void updatePossibleTravelers(String? groupId, String? travelId) async {
    print("updatePossibleTravelers started!");
    /* Firebaseのshown_travelを取ってくる */
    final ref = FirebaseDatabaseService.currentUserShownTravel;
    if (ref == null) {
      print("shown_travel Ref is null!!");
    }

    final snapshot = await ref?.get();
    if (snapshot == null || !snapshot.exists) {
      print("snapshot is empty!! updatePossibleTravelers");
    } else {
      final data = snapshot.value as Map<dynamic, dynamic>;
      //ここでgroupIdとtravelIdがとれた。
      _adminGroupId = data["groupId"];
    }

    if (_selectedTravelId != null && _selectedGroupId != null) {
      //もし引数が両方nullでなかったら上書きする
      _adminGroupId = _selectedGroupId;
    }

    final membersSnapshot =
        await FirebaseDatabaseService.groupMembersRef(_adminGroupId!).get();
    if (!membersSnapshot.exists) {
      print("membersSnapshot is empty!!! updatePossibleTravelers");
    }
    final membersData = membersSnapshot.value as Map<dynamic, dynamic>;
    _possibleTravelers = [];
    membersData.forEach((key, value) {
      _possibleTravelers.add(
        TravelerInfo(uid: key, email: value["email"], isChecked: true),
      );
    });
    _possibleTravelers.forEach((traveler) {
      print("${traveler.email} ${traveler.uid}");
    });
    setState(() {
      print("Set Stateしないとif文のところが更新されないっぽい？");
    });
    print("updatePossibleTravers finished!!");
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        /**
         * 現在のshownTravelIdを_selectedTravelIdにいれておく。
         */
        final ShownTravelBasic? shownTravel =
            await FirebaseDatabaseService.getCurrentShownTravel();
        if (shownTravel == null) {
          print("まだshownTravelを設定していないか、エラーが出ている");
        } else {
          _selectedTravelId = shownTravel.travelId;
          _selectedGroupId = shownTravel.groupId;
          updatePossibleTravelers(_selectedTravelId, _selectedGroupId);
        }

        /**
         * usersの自分の配下のjoined_groupsから、所属しているグループのidを取得
         * */
        final joinedGroupRef =
            await FirebaseDatabaseService.currentUserJoinedGroupRef;
        if (joinedGroupRef == null) {
          print("joinedGroupRef=null.. ここに来るのはまずい");
          return;
        }

        final joinedGroupsSnapshot = await joinedGroupRef.get();
        if (!joinedGroupsSnapshot.exists) {
          print("You might not join any group.");
          _joinedGroupEmptyFlag = true;
          return;
        }

        final joinedGroupMap =
            joinedGroupsSnapshot.value as Map<dynamic, dynamic>;

        //.keys.toListの段階ではString型になっていない。
        joinedGroupMap.keys.toList().forEach((groupId) {
          final GroupTravels buf = GroupTravels(
            groupId: groupId.toString(),
            travels: [],
          );
          _joinedGroupTravel.add(buf);
        });

        if (_joinedGroupTravel.isEmpty) {
          print("_joinedGroups is empty");
          return;
        }

        if (widget.userRole == UserRole.normal ||
            widget.userRole == UserRole.admin) {
          /**
           * 通常ユーザーの場合は、join_groupsのGroup内のtravelsだけ取る
           */
          print("IS this ??");
          _joinedGroupTravel.forEach((joinedGroupTravel) {
            //travelsだけ追加する
            FirebaseDatabaseService.travelsRef(
              joinedGroupTravel.groupId,
            ).get().then((snapshot) {
              if (snapshot.exists) {
                final travels = snapshot.value as Map<dynamic, dynamic>;
                travels.forEach((travelId, travelData) {
                  // Assuming 'name' is the travel name
                  joinedGroupTravel.travels.add(
                    TravelInfo(id: travelId, name: travelData['name']),
                  );
                });
                setState(() {
                  /* finallyでsetStateしているが、finallyはthenの跡を待ってくれない。 */
                  /* だからここでsetStateしないと、UIに反映されない */
                  print(
                    "This is done after finally, because finally doesn't wait for then.",
                  );
                });
              } else {
                print("No travels found for group $joinedGroupTravel");
              }
            });
          });
        }

        if (widget.userRole == UserRole.admin) {
          /**
           * groupKeysからtravelIdを取ってきて、それから
           * 各travelIdの名前を取ってくるって感じの方が良いな
           */
          _groupKeys = await FirebaseDatabaseService.getGroupKeys();
          setState(() {
            _selectedGroupForCreation = _groupKeys?.keys.first.toString();
          });
        } else {}
      } catch (e) {
        print("Error:$e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userStore = context.watch<UserStore>();
    final expenseStore = context.watch<ExpenseStore>();
    final itineraryStore = context.watch<ItineraryStore>();
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* ラジオボタンエリア */
              Column(
                children:
                    !_joinedGroupEmptyFlag
                        ? _joinedGroupTravel.map((groupTravel) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Group:${groupTravel.groupId}"),
                              if (groupTravel.travels.isNotEmpty)
                                ...groupTravel.travels.map((travel) {
                                  return RadioListTile<String>(
                                    title: Text(travel.name),
                                    value: travel.id,
                                    groupValue: _selectedTravelId,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedTravelId = value;
                                        _selectedGroupId = groupTravel.groupId;
                                      });
                                      if (widget.userRole == UserRole.admin) {
                                        updatePossibleTravelers(
                                          _selectedGroupId,
                                          _selectedTravelId,
                                        );
                                      }
                                    },
                                  );
                                }).toList()
                              else
                                Text("旅行が作成されていません(管理者に連絡してください)"),
                            ],
                          );
                        }).toList()
                        : [Text("参加しているグループがありません。参加者割当てを行っていないかも。")],
              ),
              SizedBox(height: 30),
              if (!_isLoading)
                RoundedButton(
                  title: "表示旅行変更(決定)",
                  enabled: !_joinedGroupEmptyFlag,
                  onPressed: () async {
                    final travelBasic = ShownTravelBasic(
                      groupId: _selectedGroupId,
                      travelId: _selectedTravelId,
                    );
                    final ret =
                        await FirebaseDatabaseService.setCurrentUserShownTravel(
                          travelBasic,
                        );
                    print("setCurrentUserShownTravel result: $ret");
                    if (ret.isSuccess) {
                      final userStoreRet =
                          await userStore
                              .loadShownTravelWithManagerWithNotify();
                      if (!userStoreRet.isSuccess) {
                        print(
                          "Failed to load shown travel after setting it: ${userStoreRet.error?.errorMessage}",
                        );
                        return;
                      }
                    }
                    if (widget.userRole == UserRole.admin) {
                      updatePossibleTravelers(
                        _selectedGroupId,
                        _selectedTravelId,
                      );
                    }

                    Navigator.pop(context);
                  },
                ),

              /**
               * ここから下はAdmin専用
               */
              if (widget.userRole == UserRole.admin)
                Column(
                  children: [
                    Text("======================"),
                    SizedBox(height: 30),
                    BasicTextField(
                      hintText: "旅行名",
                      onChanged: (name) {
                        _newTravelName = name;
                      },
                    ),
                    SizedBox(height: 10),
                    if (_groupKeys != null)
                      DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedGroupForCreation,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGroupForCreation = newValue!;
                          });
                        },
                        items:
                            _groupKeys!.keys.map<DropdownMenuItem<String>>((
                              key,
                            ) {
                              print(key);
                              return DropdownMenuItem<String>(
                                value: key,
                                child: Text(
                                  key.toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                      )
                    else
                      Text("group がnull"),

                    RoundedButton(
                      title: "旅行作成",
                      onPressed: () async {
                        if (_selectedGroupForCreation == null) {
                          print("_selectedGroupForCreation is null!!!");
                          return;
                        }

                        if (_newTravelName == "") {
                          print("_newTravelName is empty");
                          return;
                        }

                        final newTravelRef =
                            FirebaseDatabaseService.travelsRef(
                              _selectedGroupForCreation!,
                            ).push();
                        await newTravelRef.set({
                          "name": _newTravelName,
                          "createdAt": DateTime.now().toIso8601String(),
                          //"総監督": "default",
                        });

                        /* groupKeysの配下にもいれる */
                        final travelIdInGroupKeysRef =
                            FirebaseDatabaseService.groupIdInGroupKeysRef(
                              _selectedGroupForCreation!,
                            );
                        await travelIdInGroupKeysRef.update({
                          newTravelRef.key!: true,
                        });

                        Navigator.pop(context);
                      },
                    ),

                    SizedBox(height: 50),
                    Text("==============参加者選択====================="),
                    Text("=====travel id:${_selectedTravelId}"),
                    /* まじで汚いコード泣きがする。無駄が多いというか。 */
                    if (_possibleTravelers.length > 0)
                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                            NeverScrollableScrollPhysics(), // Nestedスクロール防止
                        itemCount: _possibleTravelers.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Text(_possibleTravelers[index].email),
                            value: _possibleTravelers[index].isChecked,
                            onChanged:
                                (value) => {
                                  setState(() {
                                    _possibleTravelers[index] =
                                        _possibleTravelers[index].copyWith(
                                          isChecked: value ?? true,
                                        );
                                  }),
                                },
                          );
                        },
                      ),
                    RoundedButton(
                      title: "参加者更新",
                      onPressed: () async {
                        print("参加者更新 was pressed!");
                        if (_selectedGroupId == null ||
                            _selectedTravelId == null) {
                          return;
                        }
                        Map<String, Map<String, Object?>> travelers = {};
                        _possibleTravelers.forEach((TravelerInfo traveler) {
                          if (traveler.isChecked == true) {
                            travelers[traveler.uid] = {
                              "uid": traveler.uid,
                              "email": traveler.email,
                            };
                          }
                        });
                        await FirebaseDatabaseService.singleTravelParticipantsRef(
                          _selectedGroupId!,
                          _selectedTravelId!,
                        ).set(travelers);
                        print("updated $travelers");

                        /* 手動で更新しないといけない */
                        expenseStore.loadAllParitcipants();
                        itineraryStore.loadAllParticipants();
                      },
                    ),
                  ], //adminのみのwidget
                ),
            ],
          ),
        ),
      ),
    );
  }
}
