import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/components/SettingMenuBar.dart';
import 'package:my_travel_app/constants.dart';
import 'package:my_travel_app/routing/routes.dart';
import 'package:my_travel_app/ui/main/Settings/main/view_models/settings_viewmodel.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    /* ログインをしたときに切り替える */
    final viewModel = context.watch<SettingsViewModel>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SettingMenubar(
              onPressed: () {
                //Navigator.pushNamed(context, ProfileScreen.id);
              },
              menuName: "プロフィール",
            ),
            SettingMenubar(
              onPressed: () {
                context.push(Routes.settings_travel_select);
              },
              menuName: "表示旅行選択",
            ),

            if (viewModel.roleState.data == UserRole.admin) ...[
              SizedBox(height: 50),
              SettingMenubar(onPressed: () {}, menuName: "旅行新規作成"),
              SettingMenubar(
                onPressed: () {
                  context.push(Routes.settings_create_group);
                },
                menuName: "グループ作成",
              ),
              // SettingMenubar(onPressed: () {}, menuName: "グループ削除"),
              SettingMenubar(onPressed: () {}, menuName: "旅行削除"),
            ], //adminだったらこちらを表示
            SettingMenubar(
              onPressed: () {
                context.push(Routes.settings_version_info);
              },
              menuName: "バージョン情報/ソースコード",
            ),
            TextButton(
              onPressed: () async {
                viewModel.signOut();
              },
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
