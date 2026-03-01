import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/components/SettingMenuBar.dart';
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
                // userStore.userRole != ''
                //     ? Navigator.pushNamed(
                //       context,
                //       TravelManageScreen.id,
                //       arguments: {
                //         'userRole': userStore.userRole,
                //       }, //これ危ないな。すぐクラッシュしそう。
                //     )
                //     : null;
              },
              menuName: "aa",
              // userStore.userRole == UserRole.admin
              //     ? "表示旅行選択  (旅行新規作成)"
              //     : "表示旅行選択",
            ),
            // if (userStore.userRole == UserRole.admin) ...[
            //   SizedBox(height: 50),
            //   SettingMenubar(
            //     onPressed: () {
            //       Navigator.pushNamed(context, CreateGroupScreen.id);
            //     },
            //     menuName: "グループ作成",
            //   ),
            //   SettingMenubar(
            //     onPressed: () {
            //       Navigator.pushNamed(context, DeleteGroupScreen.id);
            //     },
            //     menuName: "グループ削除",
            //   ),
            //   SettingMenubar(
            //     onPressed: () {
            //       Navigator.pushNamed(context, GeneralManagerSelectScreen.id);
            //     },
            //     menuName: "プランナー選択",
            //   ),
            //   SettingMenubar(onPressed: () {}, menuName: "旅行削除"),
            // ], //adminだったらこちらを表示
            // SettingMenubar(
            //   onPressed: () {
            //     Navigator.pushNamed(context, VersionInfoScreen.id);
            //   },
            //   menuName: "バージョン情報",
            // ),
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
