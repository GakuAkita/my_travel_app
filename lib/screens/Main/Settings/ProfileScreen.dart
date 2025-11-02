import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/Services/AuthService.dart';
import 'package:my_travel_app/components/TopAppBar.dart';

import '../../../Services/FirebaseDatabaseService.dart';
import '../../../components/BasicTextField.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const id = "profile_screen";
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameTextController = TextEditingController();

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    Future.microtask(() async {
      _userId = AuthService.currentUser?.uid ?? "Unable to get uid";

      final userNameSnapshot =
          await FirebaseDatabaseService.currentUserProfileRef?.get();

      if (userNameSnapshot != null && userNameSnapshot.exists) {
        _userName = userNameSnapshot.value as String;
        print("Current User Name:{$_userName}");
      } else {
        _userName = "empty";
      }

      final userEmailSnapshot =
          await FirebaseDatabaseService.currentUserEmailRef?.get();
      if (userEmailSnapshot != null && userEmailSnapshot.exists) {
        _userEmail = userEmailSnapshot.value as String;
        print("Current User Email:{$_userEmail}");
      } else {
        //サインアップのときに指定しているのでemptyになることは基本的にない
        _userEmail = "empty";
      }

      setState(() {
        _loading = false;
      });
    });
  }

  String? _userId;
  String? _userName;
  String? _userEmail;
  String _newName = "";
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true),
      body: LoadingOverlay(
        isLoading: _loading,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildInfoRow("名前", _userName),
                  _buildInfoRow("メールアドレス", _userEmail),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child:
          label == "名前" && value == "empty"
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 120, child: Text("$label:")),
                  SizedBox(
                    width: 160,
                    child: BasicTextField(
                      hintText: "名前",
                      controller:
                          _nameTextController, //関数を別で作っているからcontroller渡さないとバグる？
                      onChanged: (name) {
                        setState(() {
                          print("Name: $name");
                          _newName = name;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseDatabaseService.currentUserProfileRef
                            ?.set(_newName);
                        setState(() {
                          _userName = _newName;
                        });
                      },
                      child: Text("更新"),
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                  ),
                ],
              )
              : label ==
                  "名前" //名前は入っているけど更新したい。コードが汚いな
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 120, child: Text("$label:")),
                  Expanded(child: Text(value ?? "")),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print("empty!!!");
                        setState(() {
                          _userName = "empty";
                        });
                      },
                      child: Text("変更"),
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                  ),
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 120, child: Text("$label:")),
                  Expanded(child: Text(value ?? "")),
                ],
              ),
    );
  }
}
