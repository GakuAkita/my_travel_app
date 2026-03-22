import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/ui/core/ui/TopAppBar.dart';
import 'package:my_travel_app/ui/main/settings/group_create/view_models/group_create_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../expenses/add_edit/widgets/selected_user.dart';

class GroupCreateScreen extends StatefulWidget {
  const GroupCreateScreen({super.key});

  @override
  State<GroupCreateScreen> createState() => _GroupCreateScreenState();
}

class _GroupCreateScreenState extends State<GroupCreateScreen> {
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void dispose() {
    _groupNameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GroupCreateViewModel>();
    return Scaffold(
      appBar: TopAppBar(title: 'Create Group', automaticallyImplyLeading: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("グループ名 [英字のみ、特殊文字禁止]"),
                  TextField(controller: _groupNameController),
                ],
              ),
            ),
            /* ユーザーを全部表示 */
            if (viewModel.allUsers.hasData)
              if (viewModel.allUsers.data!.isEmpty)
                Text("ユーザーがいません")
              else
                /* チェックを変えるたびに全部再描画しているからくっそ遅い!!!! */
                /* @TODO おれしか使わないからいいが、将来的には直す!!! */
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewModel.allUsers.data!.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return UserCheckRow(
                      user: viewModel.allUsers.data!.values.elementAt(index),
                      onTap: () {
                        final traveler = viewModel.allUsers.data!.values
                            .elementAt(index);
                        print("tapped :${traveler.traveler.core.email}");
                        viewModel.switchChecked(traveler.traveler.core.uid);
                      },
                    );
                  },
                )
            else if (viewModel.allUsers.hasError)
              Text("エラーが出ています。${viewModel.allUsers.error?.errorMessage}")
            else
              Text("loading??"),

            RoundedButton(
              title: "グループ作成",
              onPressed: () async {
                if (_groupNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("グループ名を入力してください")));
                }
                final ret = await viewModel.createGroup(
                  _groupNameController.text,
                );
                if (ret.isSuccess) {
                  context.pop();
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${ret.error?.errorMessage}")),
                  );
                }
              },
            ),

            SizedBox(height: 40),
            if (viewModel.joinedGroups.hasData) ...[
              Divider(),
              Text("削除するグループ選択"),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      items:
                          viewModel.joinedGroups.data!
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, maxLines: 1),
                                );
                              })
                              .toList(),
                      value: viewModel.selectedGroupId,
                      onChanged: (String? value) {
                        viewModel.selectGroup(value);
                      },
                    ),
                  ),
                ],
              ),
              RoundedButton(
                title: "グループ削除",
                onPressed: () {
                  if (viewModel.selectedGroupId == null) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("削除するグループを選択してください")),
                    );
                    return;
                  }
                  print("Delete ${viewModel.selectedGroupId}");
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class UserCheckRow extends StatelessWidget {
  final SelectedUser user;
  final VoidCallback? onTap;

  UserCheckRow({required SelectedUser this.user, VoidCallback? this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Checkbox(value: user.isChecked, onChanged: (_) {}),
          Expanded(
            flex: 1,
            child: Text("${user.traveler.core.email}", maxLines: 1),
          ),
          Expanded(flex: 1, child: Text("${user.traveler.core.uid}")),
        ],
      ),
    );
  }
}
