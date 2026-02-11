import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_travel_app/Services/FirebaseDatabaseService.dart';
import 'package:my_travel_app/components/BasicText.dart';
import 'package:my_travel_app/components/TopAppBar.dart';

import '../../../components/BasicTextField.dart';
import '../../../components/RoundedButton.dart';

/**
 * GPTにほとんど書いてもらったので、自分ではそんなに理解していない！！
 *まあでもたくさん使う場面ではないので、なんとか!!!
 */

class CreateGroupScreen extends StatefulWidget {
  static const String id = "create_group_screen";
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  Map<String, dynamic> _users = {};

  String _newGroupName = "";

  bool _isLoading = true;

  //trueだったらグループにいれる
  Map<String, bool> checkedUsers = {};

  final TextEditingController _groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //非同期処理の再開
    Future.microtask(() async {
      try {
        setState(() {
          _isLoading = true;
        });
        final usersRef = FirebaseDatabaseService.usersRef;

        print("usersRef blocked??");
        final snapshot = await usersRef.get();
        print("usersRef was not blocked.");

        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;

          // キーを String にキャスト
          setState(() {
            _users = data.map((key, value) {
              return MapEntry(key.toString(), Map<String, dynamic>.from(value));
            });
            print("$_users");
          });
        }
      } catch (e) {
        print("エラー:$e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true, title: "グループ管理"),
      body:
          !_isLoading
              ? Column(
                children: [
                  Flexible(
                    child: ListView(
                      children:
                          _users.entries.map((entry) {
                            final id = entry.key;
                            final email = entry.value['email'];

                            return CheckboxListTile(
                              title: Text("ID: $id"),
                              subtitle: Text("Email: $email"),
                              value: checkedUsers[id] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  checkedUsers[id] = value ?? false;
                                });
                              },
                            );
                          }).toList(),
                    ),
                  ),
                  BasicTextField(
                    controller: _groupNameController,
                    hintText: 'グループ名(英語のみ!)',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9_\-@.]+'), // ← 使用を許可する文字だけ
                      ),
                    ],
                    onChanged: (value) {
                      _newGroupName = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RoundedButton(
                      title: "グループ新規作成",
                      onPressed: () async {
                        //データを作成する
                        if (_newGroupName.isEmpty) {
                          // Show an error message or return
                          // ScaffoldMessenger.of(
                          //   context,
                          // ).showSnackBar(SnackBar(content: Text('グループ名を入力してください')));
                          print("グループ名が入っていない");
                          return;
                        }

                        final existingGroups =
                            await FirebaseDatabaseService.getGroupKeys();
                        if (existingGroups != null) {
                          for (String groupKey
                              in existingGroups.keys.toList()) {
                            if (groupKey == _newGroupName) {
                              print("すでにそのグループ名は存在しています。");
                              return;
                            }
                          }
                          ;
                        }

                        // Create a new group in Firebase
                        DatabaseReference ref =
                            FirebaseDatabaseService.groupMembersRef(
                              _newGroupName,
                            );

                        // Prepare the list of users to be added to the group
                        Map<String, dynamic> selectedUsers = {};

                        checkedUsers.forEach((id, isChecked) {
                          if (isChecked) {
                            // Add the selected user to the group
                            final user = _users[id];
                            if (user != null) {
                              selectedUsers[id] = {
                                'email': user['email'],
                                'uid': id,
                              };
                            }
                          }
                        });

                        if (selectedUsers.isNotEmpty) {
                          // Add the selected users to the group's database entry
                          await ref.set(selectedUsers);

                          final groupKeysRef =
                              FirebaseDatabaseService.groupKeysRef;
                          await groupKeysRef.update({_newGroupName: true});

                          // Optionally, show a success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('グループが作成されました')),
                          );

                          // Clear the checked users and the group name
                          setState(() {
                            checkedUsers.clear();
                            _newGroupName = "";
                            _groupNameController.clear();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('ユーザーを選択してください')),
                          );
                        }
                      },
                    ),
                  ),

                  RoundedButton(
                    title: "グループ割り当て更新",
                    onPressed: () async {
                      List groups = [];
                      DatabaseReference ref =
                          await FirebaseDatabaseService.groupsRef;

                      final snapshot = await ref.get();

                      if (!snapshot.exists) {
                        print("グループが存在しません");
                        return;
                      }
                      //ここでデータ取得
                      final data = snapshot.value as Map<dynamic, dynamic>;
                      print(data);
                      groups = data.keys.toList();
                      print("Travel group list:" + groups.toString());

                      //各グループ配下のキーが
                      groups.forEach((groupName) {
                        print("-----------$groupName----------------");
                        final memberIds = data[groupName]["members"].keys;
                        memberIds.forEach((memberId) {
                          print(memberId);
                          final ref =
                              FirebaseDatabaseService.singleUserJoinedGroupRef(
                                memberId,
                              );
                          ref.update({
                            groupName: true,
                          }); //キーだけ追加ってのはできないから、boolのtrueだけしておく
                          print("$memberId : groupName$groupName added!");
                        });
                      });
                    },

                    //一個ずつグループを見ていって、そこに含まれているメンバーに対して、
                    //users/{userid}/joined_groups配下にリストで追加していく。

                    //いや、こんな操作いらないか。
                  ),
                ],
              )
              : BasicText(text: "loading.."),
    );
  }
}
