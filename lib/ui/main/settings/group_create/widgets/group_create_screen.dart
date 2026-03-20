import 'package:flutter/material.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/ui/core/ui/TopAppBar.dart';

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
    return Scaffold(
      appBar: TopAppBar(title: 'Create Group', automaticallyImplyLeading: true),
      body: Column(
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
          RoundedButton(title: "グループ作成", onPressed: () {}),
        ],
      ),
    );
  }
}
