import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/components/SettingMenuBar.dart';
import 'package:my_travel_app/routing/routes.dart';
import 'package:my_travel_app/ui/main/settings/main/view_models/settings_viewmodel.dart';

import '../../../../core/ui/section_header.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsViewModel viewModel;

  const SettingsScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    /* ログインをしたときに切り替える */
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const SectionHeader(icon: Icons.person_outline, title: "アカウント"),
            _MenuCard(
              children: [
                SettingMenubar(
                  icon: Icons.badge_outlined,
                  onPressed: () {
                    context.push(Routes.settings_profile);
                  },
                  menuName: "プロフィール",
                ),
              ],
            ),
            const SectionHeader(icon: Icons.luggage_outlined, title: "旅行"),
            _MenuCard(
              children: [
                SettingMenubar(
                  icon: Icons.flight_takeoff,
                  onPressed: () {
                    final role = viewModel.roleState.data;
                    context.push(Routes.settings_travel_select, extra: role);
                  },
                  menuName: viewModel.isAdmin ? "表示旅行選択(参加者決定)" : "表示旅行選択",
                ),
              ],
            ),
            if (viewModel.isAdmin) ...[
              //adminだったらこちらを表示
              const SectionHeader(icon: Icons.admin_panel_settings_outlined, title: "管理者メニュー"),
              _MenuCard(
                children: [
                  SettingMenubar(
                    icon: Icons.edit_calendar_outlined,
                    onPressed: () {
                      context.push(Routes.settings_create_travel);
                    },
                    menuName: "旅行新規作成/削除",
                  ),
                  SettingMenubar(
                    icon: Icons.group_add_outlined,
                    onPressed: () {
                      context.push(Routes.settings_create_group);
                    },
                    menuName: "グループ作成/削除",
                  ),
                  SettingMenubar(
                    icon: Icons.manage_accounts_outlined,
                    onPressed: () {
                      context.push(Routes.settings_planners);
                    },
                    menuName: "プランナー選択",
                  ),
                ],
              ),
            ],
            const SectionHeader(icon: Icons.info_outline, title: "アプリ"),
            _MenuCard(
              children: [
                SettingMenubar(
                  icon: Icons.code,
                  onPressed: () {
                    context.push(Routes.settings_version_info);
                  },
                  menuName: "バージョン情報",
                  subtitle: "ソースコード (GitHub)",
                ),
              ],
            ),
            const SizedBox(height: 16),
            _MenuCard(
              children: [
                ListTile(
                  leading: Icon(Icons.logout, color: colorScheme.error),
                  title: Text("Sign Out", style: TextStyle(color: colorScheme.error)),
                  onTap: () async {
                    viewModel.signOut();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// メニューをまとめて囲むカード。行の間に区切り線を入れる
class _MenuCard extends StatelessWidget {
  final List<Widget> children;

  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[if (i > 0) const Divider(height: 1, indent: 56), children[i]],
        ],
      ),
    );
  }
}
