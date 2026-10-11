import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/ui/main/settings/travel_select/view_models/travle_select_viewmodel.dart';

import '../../../../../constants.dart';
import '../../../../core/ui/empty_state.dart';
import '../../../../core/ui/top_app_bar.dart';

class TravelSelectScreen extends StatelessWidget {
  final String? userRole;
  final TravelSelectViewModel viewModel;

  const TravelSelectScreen({this.userRole, required this.viewModel, super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final userTravels = viewModel.userTravels;
        final hasTravels = userTravels != null && userTravels.isNotEmpty;

        return Scaffold(
          appBar: TopAppBar(title: "旅行選択", automaticallyImplyLeading: true),
          body: userTravels == null
              /* まだユーザーの旅行が取得されていない */
              ? const Center(child: CircularProgressIndicator())
              : userTravels.isEmpty
              /* 取れたけどまだ旅行が作られていない */
              ? const EmptyState(
                  icon: Icons.flight_takeoff,
                  message: "旅行が作成されていません",
                  hint: "Settingsの旅行作成から新しい旅行を作りましょう",
                )
              : RadioGroup<String>(
                  groupValue: viewModel.selectedTravelId,
                  onChanged: (value) async {
                    if (value != null) {
                      viewModel.setSelectTravelId(value);
                      viewModel.setTravelers();
                    }
                  },
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      for (final groupEntry in userTravels.entries)
                        _GroupTravelsSection(
                          groupId: groupEntry.key,
                          travels: groupEntry.value,
                          currentTravelId: viewModel.currentTravelId,
                        ),
                      if (userRole == UserRole.admin) _buildParticipantsSection(context),
                    ],
                  ),
                ),
          bottomNavigationBar: hasTravels
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: FilledButton(
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                      onPressed: viewModel.selectedTravelId == null
                          ? null
                          : () {
                              final ret = viewModel.switchToSelectedTravel();
                              if (ret.isSuccess) {
                                context.pop();
                              } else {
                                _showSnackBar(context, "${ret.error?.errorMessage}");
                              }
                            },
                      child: const Text("この旅行を表示する", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  /// Adminだけが選択中の旅行の参加者を変更できる
  Widget _buildParticipantsSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final participants = viewModel.selectableParticipants;
    final checkedCount = participants.where((p) => p.isChecked).length;
    final travelName = viewModel.selectedTravelName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        _SectionHeader(
          icon: Icons.how_to_reg_outlined,
          title: "参加者選択",
          trailing: participants.isEmpty ? null : "$checkedCount / ${participants.length}人",
        ),
        if (travelName != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              "「$travelName」の参加者を選びます(管理者のみ)",
              style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
            ),
          ),
        Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: participants.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    viewModel.selectedTravelId == null ? "旅行を選択してください" : "メンバーを読み込み中…",
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                )
              : Column(
                  children: [
                    for (int index = 0; index < participants.length; index++)
                      CheckboxListTile(
                        value: participants[index].isChecked,
                        onChanged: (val) {
                          viewModel.switchChecked(index);
                        },
                        title: Text(
                          participants[index].traveler.core.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          onPressed: participants.isEmpty
              ? null
              : () async {
                  final ret = await viewModel.setParticipants();
                  if (!context.mounted) return;
                  if (ret.isSuccess) {
                    _showSnackBar(context, "更新しました");
                    context.pop();
                  } else {
                    _showSnackBar(context, "${ret.error?.errorMessage}");
                  }
                },
          icon: const Icon(Icons.save_outlined),
          label: const Text("参加者を更新"),
        ),
      ],
    );
  }
}

/// グループごとの旅行一覧
class _GroupTravelsSection extends StatelessWidget {
  final String groupId;
  final Map<String, String> travels;
  final String? currentTravelId;

  const _GroupTravelsSection({required this.groupId, required this.travels, this.currentTravelId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final entries = travels.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(icon: Icons.groups_outlined, title: groupId),
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          child: entries.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text("旅行がありません", style: TextStyle(color: colorScheme.onSurfaceVariant)),
                )
              : Column(
                  children: [
                    for (int i = 0; i < entries.length; i++) ...[
                      if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16),
                      RadioListTile<String>(
                        value: entries[i].key,
                        title: Text(entries[i].value, maxLines: 1, overflow: TextOverflow.ellipsis),
                        secondary: entries[i].key == currentTravelId ? const _CurrentTravelChip() : null,
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;

  const _SectionHeader({required this.icon, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.primary),
            ),
          ),
          if (trailing != null)
            Text(trailing!, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _CurrentTravelChip extends StatelessWidget {
  const _CurrentTravelChip();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text("表示中", style: TextStyle(fontSize: 12, color: primary)),
    );
  }
}
