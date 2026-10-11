import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/components/SettingMenuBar.dart';
import 'package:my_travel_app/routing/routes.dart';
import 'package:my_travel_app/ui/main/settings/main/view_models/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsViewModel viewModel;

  const SettingsScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    /* ログインをしたときに切り替える */
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SettingMenubar(
                  onPressed: () {
                    context.push(Routes.settings_profile);
                  },
                  menuName: "プロフィール",
                ),
                SettingMenubar(
                  onPressed: () {
                    final role = viewModel.roleState.data;
                    context.push(Routes.settings_travel_select, extra: role);
                  },
                  menuName: viewModel.isAdmin ? "表示旅行選択(参加者決定)" : "表示旅行選択",
                ),

                if (viewModel.isAdmin) ...[
                  SizedBox(height: 50),
                  SettingMenubar(
                    onPressed: () {
                      context.push(Routes.settings_create_travel);
                    },
                    menuName: "旅行新規作成/削除",
                  ),
                  SettingMenubar(
                    onPressed: () {
                      context.push(Routes.settings_create_group);
                    },
                    menuName: "グループ作成/削除",
                  ),
                  SettingMenubar(
                    onPressed: () {
                      context.push(Routes.settings_planners);
                    },
                    menuName: "プランナー選択",
                  ),
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
      },
    );
  }
}
