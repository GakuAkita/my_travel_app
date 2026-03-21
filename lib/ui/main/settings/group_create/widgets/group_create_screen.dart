import 'package:flutter/material.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/ui/core/ui/TopAppBar.dart';
import 'package:my_travel_app/ui/main/settings/group_create/view_models/group_create_viewmodel.dart';
import 'package:provider/provider.dart';

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
                  Text("グループ名"),
                  TextField(controller: _groupNameController),
                ],
              ),
            ),
            /* ユーザーを全部表示 */
            if (viewModel.allUsers.hasData)
              if (viewModel.allUsers.data!.isEmpty)
                Text("ユーザーがいません")
              else
                ...viewModel.allUsers.data!.entries
                    .map((traveler) => Text("${traveler.key}"))
                    .toList()
            else if (viewModel.allUsers.hasError)
              Text("エラーが出ています。${viewModel.allUsers.error?.errorMessage}")
            else
              Text("loading??"),

            RoundedButton(title: "グループ作成", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
