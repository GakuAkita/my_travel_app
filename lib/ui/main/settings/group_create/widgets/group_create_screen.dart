import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/components/BasicTextField.dart';
import 'package:my_travel_app/ui/core/ui/confirm_dialog.dart';
import 'package:my_travel_app/ui/core/ui/section_header.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/settings/group_create/view_models/group_create_viewmodel.dart';

import '../../../expenses/add_edit/widgets/selected_user.dart';

class GroupCreateScreen extends StatefulWidget {
  final GroupCreateViewModel viewModel;

  const GroupCreateScreen({super.key, required this.viewModel});

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
    final viewModel = widget.viewModel;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final allUsers = viewModel.allUsers;
        final checkedCount = allUsers.data?.values.where((u) => u.isChecked).length ?? 0;
        final joinedGroups = viewModel.joinedGroups.data ?? [];

        void showSnackBar(String message) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }

        return Scaffold(
          appBar: TopAppBar(title: 'Create Group', automaticallyImplyLeading: true),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              const SectionHeader(icon: Icons.group_add_outlined, title: "新しいグループ"),
              BasicTextField(
                controller: _groupNameController,
                labelText: "グループ名",
                hintText: "group id",
                prefixIcon: const Icon(Icons.tag),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9_\-@.]+'), // ← 使用を許可する文字だけ
                  ),
                ],
                onChanged: (val) {},
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 4, 0),
                child: Text("英数字と _ - @ . のみ使えます", style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
              ),
              const SizedBox(height: 16),
              /* ユーザーを全部表示 */
              SectionHeader(
                icon: Icons.people_outline,
                title: "メンバー",
                trailing: allUsers.hasData && allUsers.data!.isNotEmpty ? "$checkedCount人選択中" : null,
              ),
              Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: allUsers.hasError
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "エラーが出ています。${allUsers.error?.errorMessage}",
                          style: TextStyle(color: colorScheme.error),
                        ),
                      )
                    : !allUsers.hasData
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : allUsers.data!.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text("ユーザーがいません", style: TextStyle(color: colorScheme.onSurfaceVariant)),
                      )
                    /* チェックを変えるたびに全部再描画しているからくっそ遅い!!!! */
                    /* @TODO おれしか使わないからいいが、将来的には直す!!! */
                    : Column(
                        children: [
                          for (final user in allUsers.data!.values)
                            UserCheckRow(
                              user: user,
                              onTap: () {
                                print("tapped :${user.traveler.core.email}");
                                viewModel.switchChecked(user.traveler.core.uid);
                              },
                            ),
                        ],
                      ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                icon: const Icon(Icons.add),
                label: const Text("グループ作成"),
                onPressed: () async {
                  if (_groupNameController.text.isEmpty) {
                    showSnackBar("グループ名を入力してください");
                    return;
                  }
                  final ret = await viewModel.createGroup(_groupNameController.text);
                  if (!context.mounted) return;
                  if (ret.isSuccess) {
                    context.pop();
                  } else {
                    showSnackBar("${ret.error?.errorMessage}");
                  }
                },
              ),
              if (viewModel.joinedGroups.hasData) ...[
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 8),
                const SectionHeader(icon: Icons.delete_outline, title: "グループ削除"),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: viewModel.selectedGroupId,
                  hint: const Text("削除するグループ選択"),
                  items: joinedGroups.map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value, maxLines: 1));
                  }).toList(),
                  onChanged: (String? value) {
                    viewModel.selectGroup(value);
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
                  label: const Text("グループ削除"),
                  onPressed: viewModel.selectedGroupId == null
                      ? null
                      : () async {
                          final groupId = viewModel.selectedGroupId;
                          final confirmed = await showConfirmDialog(
                            context,
                            title: "グループを削除しますか？",
                            message: "「$groupId」を削除します。この操作は取り消せません。",
                            confirmLabel: "削除",
                          );
                          if (!confirmed) return;
                          print("Delete $groupId");
                          final ret = await viewModel.deleteGroup();
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

class UserCheckRow extends StatelessWidget {
  final SelectedUser user;
  final VoidCallback? onTap;

  const UserCheckRow({required this.user, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: user.isChecked,
      onChanged: (_) => onTap?.call(),
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(user.traveler.core.email, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        user.traveler.core.uid,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
