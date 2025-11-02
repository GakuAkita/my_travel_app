import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/TravelInfo.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/Services/FirebaseDatabaseService.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/components/TopAppBar.dart';

import '../../../components/BasicText.dart';

class GeneralManagerSelectScreen extends StatefulWidget {
  static const String id = "general_manager_select_screen";
  const GeneralManagerSelectScreen({super.key});

  @override
  State<GeneralManagerSelectScreen> createState() =>
      _GeneralManagerSelectScreenState();
}

class _GeneralManagerSelectScreenState
    extends State<GeneralManagerSelectScreen> {
  List<GroupTravels> _groupTravels = [];

  String? _selectedTravelId;
  String? _selectedGroupId;

  TravelerBasic? _generalManager;

  /* groupIdとtravelIdをキーに、旅行者を中に格納 */
  Map<String, Map<String, List<TravelerBasic>>> _allTravelers = {};

  @override
  void initState() {
    super.initState();
    /**
     * group_keysを取って、そこの配下にあるtravelIdを全部とる。
     */
    Future.microtask(() async {
      try {
        final Map<String, dynamic>? rawMap =
            await FirebaseDatabaseService.getGroupKeys();
        if (rawMap == null) {
          /* groupKeysがない */
          return;
        }
        for (String groupId in rawMap.keys) {
          final value = rawMap[groupId];
          if (value == true) {
            print("${groupId} No travel is created..");
            _groupTravels.add(GroupTravels(groupId: groupId, travels: []));
          } else {
            List<TravelInfo> buf = [];
            for (final k in value.keys) {
              final String travelId = k.toString();
              /* 各keyに対して、旅行名を取ってくる */
              final nameSnap =
                  await FirebaseDatabaseService.singleTravelNameRef(
                    groupId,
                    travelId,
                  ).get();
              String travelName = nameSnap.value as String;
              buf.add(TravelInfo(id: travelId, name: travelName));
            }
            _groupTravels.add(GroupTravels(groupId: groupId, travels: buf));
          }
        }

        print("Get travelers");
        /* _groupTravelsをまたfor文で回して参加者の情報を取ってくる */
        for (final GroupTravels trl in _groupTravels) {
          final String groupId = trl.groupId;
          for (TravelInfo travelBasic in trl.travels) {
            final String travelId = travelBasic.id;
            final travelersSnap =
                await FirebaseDatabaseService.singleTravelParticipantsRef(
                  groupId,
                  travelId,
                ).get();
            if (!travelersSnap.exists) {
              print("$groupId $travelId travelers not exist");
            } else {
              final buf = travelersSnap.value as Map;
              final bufList =
                  buf.keys.map((uid) {
                    return TravelerBasic.convFromMap(buf[uid]);
                  }).toList();
              _allTravelers[groupId] = {travelId: bufList};
            }
          }
        }
        setState(() {});
      } catch (e) {
        print("Error :$e");
      } finally {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(title: "総監督を選択", automaticallyImplyLeading: true),
      body:
          _groupTravels.isNotEmpty
              ? Column(
                children: [
                  ..._groupTravels.map((groupTravel) {
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
                              },
                            );
                          }).toList()
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [Text("旅行が作成されていません")],
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 30),
                  Divider(),

                  if (_allTravelers.isNotEmpty &&
                      _selectedTravelId != null) ...[
                    ..._allTravelers[_selectedGroupId]![_selectedTravelId]!.map((
                      traveler,
                    ) {
                      return RadioListTile(
                        title: BasicText(text: traveler.email),
                        value: traveler,
                        groupValue: _generalManager,
                        onChanged: (value) {
                          setState(() {
                            _generalManager = traveler;
                          });
                          print(
                            "selected general Manager:${_generalManager!.email}",
                          );
                        },
                      );
                    }),
                    RoundedButton(
                      title: "総監督決定",
                      onPressed: () async {
                        if (_selectedGroupId == null ||
                            _selectedTravelId == null) {
                          print(
                            "groupId or travelId is null. ${_selectedGroupId} ${_selectedTravelId}",
                          );
                          return;
                        }
                        final ref =
                            FirebaseDatabaseService.singleTravelGManagerRef(
                              _selectedGroupId!,
                              _selectedTravelId!,
                            );

                        await ref.set({
                          "uid": _generalManager!.uid,
                          "email": _generalManager!.email,
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ],
              )
              : Text("groupIdなし?"),
    );
  }
}
