import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/core/utils/currency_format.dart';
import 'package:my_travel_app/ui/core/ui/bottom_action_bar.dart';
import 'package:my_travel_app/ui/core/ui/confirm_dialog.dart';
import 'package:my_travel_app/ui/core/ui/section_header.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/expenses/add_edit/view_models/add_edit_expense_viewmodel.dart';
import 'package:my_travel_app/ui/main/expenses/add_edit/widgets/selected_user.dart';

import '../../../../../components/BasicTextField.dart';
import '../../../../../data/model/traveler/traveler_basic.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final AddEditExpenseViewModel viewModel;

  const AddEditExpenseScreen({super.key, required this.viewModel});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  /// _travelersをそのままドロップダウンのリストにすると、
  /// その後で支払者のチェックボックスを切り替えた時、ドロップダウンの方にも影響が行ってしまい
  /// クラッシュする
  List<SelectedUser> _travelersOptions = [];

  /* チェックされた人(支払われた人) */
  TravelerBasic? _payer;

  /**
   * 支払い用の選択肢と誰の支払いか(チェック付き)の配列を
   * 分けて2つ作らないとエラーが出る。
   * インスタンスを別にしないといけないからだと思う。
   */

  /// グループメンバーをいれる
  List<TravelerBasic> _payerOption = [];

  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _expenseItemController = TextEditingController();

  @override
  void dispose() {
    _expenseController.dispose();
    _expenseItemController.dispose();
    super.dispose();
  }

  void initTravelerOptions() {
    final viewModel = widget.viewModel;
    /* エラーが出ているときは弾いた方が良い？ */

    /// 本当はViewModel内にOptionsらも格納したかったが、無理そう、、
    if (viewModel.expenseId == null) {
      ///新規追加のとき
      ///参加者のみチェック
      _travelersOptions = viewModel.groupMembers.map((member) {
        final bool isParticipant = viewModel.participants.any((p) => p.uid == member.core.uid);
        return SelectedUser(traveler: member, isChecked: isParticipant);
      }).toList();
    } else {
      final reimbursedBy = viewModel.initialExpense?.reimbursedBy;
      if (reimbursedBy != null) {
        // 最初にreimbursedBYになっているユーザーだけチェック
        _travelersOptions = viewModel.groupMembers.map((member) {
          final bool isChecked = reimbursedBy.containsKey(member.core.uid);
          return SelectedUser(traveler: member, isChecked: isChecked);
        }).toList();
      }
    }
  }

  void initPayer() {
    final viewModel = widget.viewModel;
    _payerOption = viewModel.groupMembers;
    /* 編集時は元の支払者、新規追加時は自分 */
    final payerUid = viewModel.initialExpense?.payer.uid ?? viewModel.uid;
    for (var member in _payerOption) {
      if (member.core.uid == payerUid) {
        _payer = member;
      }
    }
  }

  @override
  void initState() {
    final viewModel = widget.viewModel;
    super.initState();

    initTravelerOptions();
    initPayer();

    if (viewModel.expenseId != null) {
      /* コントローラにも本体にも同じ値をいれないといけない */
      /* 整数のときは "30000.0" ではなく "30000" と表示する */
      final expense = viewModel.initialExpense?.expense;
      _expenseController.text = expense == null
          ? ""
          : (expense == expense.roundToDouble() ? expense.toInt().toString() : expense.toString());

      /* expenseはControllerと中身が別なので、 */
      _expenseItemController.text = viewModel.initialExpense?.expenseItem ?? "";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final checkedCount = _travelersOptions.where((t) => t.isChecked).length;
        final amount = double.tryParse(_expenseController.text);
        final perPerson = amount != null && checkedCount > 0 ? amount / checkedCount : null;

        return Scaffold(
          appBar: TopAppBar(automaticallyImplyLeading: true, title: viewModel.expenseId == null ? "費用を追加" : "費用を編集"),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              const SectionHeader(icon: Icons.receipt_long_outlined, title: "内容"),
              DropdownButtonFormField<TravelerBasic>(
                isExpanded: true,
                initialValue: _payer,
                decoration: const InputDecoration(labelText: "支払った人", prefixIcon: Icon(Icons.account_circle_outlined)),
                items: _travelersOptions.map((traveler) {
                  return DropdownMenuItem<TravelerBasic>(
                    value: traveler.traveler,
                    child: Text(traveler.traveler.displayName, maxLines: 1, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (TravelerBasic? newTraveler) {
                  setState(() {
                    _payer = newTraveler;
                  });
                },
              ),
              const SizedBox(height: 12),
              BasicTextField(
                controller: _expenseItemController,
                labelText: "品目",
                hintText: "何に使ったか",
                prefixIcon: const Icon(Icons.edit_note),
                onChanged: (memo) {
                  /* Controllerの値をそのまま使う */
                },
              ),
              const SizedBox(height: 12),
              BasicTextField(
                controller: _expenseController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                labelText: "金額",
                hintText: "0",
                prefixIcon: const Icon(Icons.currency_yen),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                onChanged: (value) {
                  String sanitized = value.replaceFirst(RegExp(r'^0+'), '');
                  if (value != sanitized) {
                    // 先頭0があった場合は除去して再設定
                    _expenseController.value = TextEditingValue(
                      text: sanitized,
                      selection: TextSelection.collapsed(offset: sanitized.length),
                    );
                  }
                  /* 1人あたりの金額を更新する */
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              SectionHeader(
                icon: Icons.group_outlined,
                title: "割り勘する人",
                trailing: "$checkedCount / ${_travelersOptions.length}人",
              ),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _travelersOptions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final traveler = entry.value;
                  return FilterChip(
                    label: Text(traveler.traveler.displayName),
                    selected: traveler.isChecked,
                    onSelected: (bool newValue) {
                      setState(() {
                        _travelersOptions[index] = traveler.copyWith(isChecked: newValue);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() {
                      _travelersOptions = [for (final t in _travelersOptions) t.copyWith(isChecked: true)];
                    }),
                    child: const Text("全員"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _travelersOptions = [for (final t in _travelersOptions) t.copyWith(isChecked: false)];
                    }),
                    child: const Text("クリア"),
                  ),
                  const Spacer(),
                  if (perPerson != null)
                    Text(
                      "1人 ${formatYen(perPerson)}",
                      style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
              if (viewModel.expenseId != null) ...[
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: colorScheme.error,
                    side: BorderSide(color: colorScheme.error),
                  ),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text("費用を削除"),
                  onPressed: () async {
                    final confirmed = await showConfirmDialog(
                      context,
                      title: "費用を削除しますか？",
                      message: "「${_expenseItemController.text}」を削除します。この操作は取り消せません。",
                      confirmLabel: "削除",
                    );
                    if (!confirmed) return;
                    /* 削除する */
                    final ret = await viewModel.deleteExpense();
                    if (!context.mounted) return;
                    if (ret.isSuccess) {
                      context.pop();
                    } else {
                      _showSnackBar(ret.error?.errorMessage ?? "保存に失敗しました");
                    }
                  },
                ),
              ],
            ],
          ),
          bottomNavigationBar: BottomActionBar(
            label: viewModel.expenseId == null ? "費用を保存" : "費用を更新",
            onPressed: _save,
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    final viewModel = widget.viewModel;
    final expenseResult = viewModel.createExpenseFromInput(
      _payer,
      _travelersOptions,
      _expenseItemController.text,
      _expenseController.text,
    );

    if (expenseResult.isFailed) {
      _showSnackBar("${expenseResult.error?.errorMessage}");
      return;
    } else if (!expenseResult.isSuccess) {
      /* Unknown state */
      _showSnackBar("Unknown Error. It seems to be a coding error.");
      return;
    }

    final expense = expenseResult.data;
    if (expense == null) {
      _showSnackBar("Expense is null.　Coding error.");
      return;
    }

    final ret = await viewModel.addUpdateExpense(expense);
    if (!mounted) return;
    if (ret.isSuccess) {
      /* リスナー経由で更新されるはず */
      context.pop();
    } else {
      _showSnackBar(ret.error?.errorMessage ?? "保存に失敗しました");
    }
  }
}
