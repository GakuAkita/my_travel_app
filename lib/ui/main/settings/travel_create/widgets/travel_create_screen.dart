import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/components/BasicTextField.dart';
import 'package:my_travel_app/ui/core/ui/confirm_dialog.dart';
import 'package:my_travel_app/ui/core/ui/empty_state.dart';
import 'package:my_travel_app/ui/core/ui/section_header.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/settings/travel_create/view_models/travel_create_viewmodel.dart';

class TravelCreateScreen extends StatefulWidget {
  final TravelCreateViewModel viewModel;

  const TravelCreateScreen({super.key, required this.viewModel});

  @override
  State<TravelCreateScreen> createState() => _TravelCreateScreenState();
}

class _TravelCreateScreenState extends State<TravelCreateScreen> {
  final TextEditingController _travelNameController = TextEditingController();

  @override
  void dispose() {
    _travelNameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final groupIds = viewModel.joinedGroupIds.data ?? [];
        final userTravels = viewModel.userTravels.data ?? {};

        void showSnackBar(String message) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }

        String? travelNameOf(String? travelId) {
          for (final travels in userTravels.values) {
            if (travels.containsKey(travelId)) return travels[travelId];
          }
          return null;
        }

        return Scaffold(
          appBar: TopAppBar(title: "Create Travel", automaticallyImplyLeading: true),
          body: groupIds.isEmpty
              ? const EmptyState(icon: Icons.groups_outlined, message: "参加しているグループがありません", hint: "先にグループを作成してください")
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  children: [
                    const SectionHeader(icon: Icons.edit_calendar_outlined, title: "新しい旅行"),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: viewModel.selectedGroupId,
                      decoration: const InputDecoration(labelText: "グループ選択", prefixIcon: Icon(Icons.groups_outlined)),
                      items: groupIds.map((id) {
                        return DropdownMenuItem<String>(value: id, child: Text(id, maxLines: 1));
                      }).toList(),
                      onChanged: (selected) {
                        viewModel.selectGroup(selected);
                      },
                    ),
                    const SizedBox(height: 12),
                    BasicTextField(
                      controller: _travelNameController,
                      labelText: "旅行名",
                      hintText: "例: 京都旅行2026",
                      prefixIcon: const Icon(Icons.luggage_outlined),
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      icon: const Icon(Icons.add),
                      label: const Text("旅行作成"),
                      onPressed: () async {
                        if (_travelNameController.text.isEmpty) {
                          showSnackBar("旅行名を入力してください");
                          return;
                        }
                        final travelName = _travelNameController.text;
                        final ret = await viewModel.createTravel(travelName: travelName);
                        if (!context.mounted) return;
                        if (ret.isSuccess) {
                          context.pop();
                        } else {
                          showSnackBar("${ret.error?.errorMessage}");
                        }
                      },
                    ),
                    if (userTravels.values.any((travels) => travels.isNotEmpty)) ...[
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 8),
                      const SectionHeader(icon: Icons.delete_outline, title: "旅行削除"),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: viewModel.travelIdDeleted,
                        hint: const Text("削除する旅行を選択"),
                        items: userTravels.entries.expand((entry) {
                          final groupId = entry.key;
                          final travels = entry.value;

                          return travels.entries.map((travelEntry) {
                            final travelId = travelEntry.key;
                            final travelName = travelEntry.value;

                            return DropdownMenuItem<String>(
                              value: travelId,
                              child: Text("$travelName ($groupId)", maxLines: 1, overflow: TextOverflow.ellipsis),
                            );
                          });
                        }).toList(),
                        onChanged: (val) {
                          ///表示はtravel名になっているが、内部で保持しているのはtravelId
                          print(val);
                          viewModel.selectTravelId(val);
                        },
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: colorScheme.error,
                          side: BorderSide(color: colorScheme.error),
                        ),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text("旅行削除"),
                        onPressed: viewModel.travelIdDeleted == null
                            ? null
                            : () async {
                                final name = travelNameOf(viewModel.travelIdDeleted) ?? "";
                                final confirmed = await showConfirmDialog(
                                  context,
                                  title: "旅行を削除しますか？",
                                  message: "「$name」のしおりと費用もすべて削除されます。この操作は取り消せません。",
                                  confirmLabel: "削除",
                                );
                                if (!confirmed) return;
                                final ret = await viewModel.deleteTravel();
                                if (!context.mounted) return;
                                if (ret.isSuccess) {
                                  context.pop();
                                } else {
                                  showSnackBar("${ret.error?.errorMessage}");
                                }
                              },
                      ),
                    ],
                  ],
                ),
        );
      },
    );
  }
}
