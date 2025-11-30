import 'package:flutter/material.dart';
import 'package:my_travel_app/components/SettingMenuBar.dart';
import 'package:my_travel_app/constants.dart';
import 'package:my_travel_app/screens/Main/Settings/DeleteGroupScreen.dart';
import 'package:my_travel_app/screens/Main/Settings/GeneralManagerSelectScreen.dart';
import 'package:provider/provider.dart';

import '../../../Services/AuthService.dart';
import '../../../Store/ItineraryStore.dart';
import '../../../Store/UserStore.dart';
import '../../Start/StartScreen.dart';
import 'CreateGroupScreen.dart';
import 'ProfileScreen.dart';
import 'TravelManageScreen.dart';
import 'VersionInfoScreen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    /* ログインをしたときに切り替える */
    final userStore = Provider.of<UserStore>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SettingMenubar(
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.id);
              },
              menuName: "プロフィール",
            ),
            SettingMenubar(
              onPressed: () {
                userStore.userRole != ''
                    ? Navigator.pushNamed(
                      context,
                      TravelManageScreen.id,
                      arguments: {
                        'userRole': userStore.userRole,
                      }, //これ危ないな。すぐクラッシュしそう。
                    )
                    : null;
              },
              menuName:
                  userStore.userRole == UserRole.admin
                      ? "表示旅行選択  (旅行新規作成)"
                      : "表示旅行選択",
            ),
            if (userStore.userRole == UserRole.admin) ...[
              SizedBox(height: 50),
              SettingMenubar(
                onPressed: () {
                  Navigator.pushNamed(context, CreateGroupScreen.id);
                },
                menuName: "グループ作成",
              ),
              SettingMenubar(
                onPressed: () {
                  Navigator.pushNamed(context, DeleteGroupScreen.id);
                },
                menuName: "グループ削除",
              ),
              SettingMenubar(
                onPressed: () {
                  Navigator.pushNamed(context, GeneralManagerSelectScreen.id);
                },
                menuName: "プランナー選択",
              ),
              SettingMenubar(onPressed: () {}, menuName: "旅行削除"),
            ], //adminだったらこちらを表示
            SettingMenubar(
              onPressed: () {
                Navigator.pushNamed(context, VersionInfoScreen.id);
              },
              menuName: "バージョン情報",
            ),
            TextButton(
              onPressed: () async {
                //userStore.;/* 初期化 */
                final itineraryStore = context.read<ItineraryStore>();
                if (itineraryStore.editMode) {
                  await itineraryStore.setEditMode(false);
                }

                await _authService.signOut();
                userStore.clearAllData();
                itineraryStore.clearAllData();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  StartScreen.id,
                  (Route<dynamic> route) => false,
                );
              },
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
