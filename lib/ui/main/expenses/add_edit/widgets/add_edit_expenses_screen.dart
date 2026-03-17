import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/components/BasicText.dart';
import 'package:my_travel_app/ui/core/ui/TopAppBar.dart';
import 'package:my_travel_app/ui/main/expenses/add_edit/view_models/add_edit_expense_viewmodel.dart';
import 'package:my_travel_app/ui/main/expenses/add_edit/widgets/selected_traveler.dart';
import 'package:provider/provider.dart';

import '../../../../../components/BasicTextField.dart';
import '../../../../../components/RoundedButton.dart';
import '../../../../../data/model/traveler/traveler_basic.dart';

class AddEditExpenseScreen extends StatefulWidget {
  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  /// _travelersをそのままドロップダウンのリストにすると、
  /// その後で支払者のチェックボックスを切り替えた時、ドロップダウンの方にも影響が行ってしまい
  /// クラッシュする
  List<SelectedTraveler> _travelersOptions = [];

  /* チェックされた人(支払われた人) */
  TravelerBasic? _payer;

  /**
   * 支払い用の選択肢と誰の支払いか(チェック付き)の配列を
   * 分けて2つ作らないとエラーが出る。
   * インスタンスを別にしないといけないからだと思う。
   */

  /// グループメンバーをいれる
  List<TravelerBasic> _payerOption = [];

  int _expense = 0;
  String _expenseItem = "";

  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _expenseItemController = TextEditingController();

  @override
  void dispose() {
    _expenseController.dispose();
    _expenseItemController.dispose();
    super.dispose();
  }

  void initTravelerOptions() {
    final viewModel = context.read<AddEditExpenseViewModel>();
    /* エラーが出ているときは弾いた方が良い？ */

    /// 本当はViewModel内にOptionsらも格納したかったが、無理そう、、
    if (viewModel.expenseId == null) {
      ///新規追加のとき
      ///参加者のみチェック
      _travelersOptions =
          viewModel.groupMembers.map((member) {
            final bool isParticipant = viewModel.participants.any(
              (p) => p.uid == member.core.uid,
            );
            return SelectedTraveler(traveler: member, isChecked: isParticipant);
          }).toList();
    } else {
      final reimbursedBy = viewModel.initialExpense?.reimbursedBy;
      if (reimbursedBy != null) {
        // 最初にreimbursedBYになっているユーザーだけチェック
        _travelersOptions =
            viewModel.groupMembers.map((member) {
              final bool isChecked = reimbursedBy.containsKey(member.core.uid);
              return SelectedTraveler(traveler: member, isChecked: isChecked);
            }).toList();
      }
    }
  }

  void initPayer() {
    final viewModel = context.read<AddEditExpenseViewModel>();
    _payerOption = viewModel.groupMembers;
    for (var member in _payerOption) {
      if (member.core.uid == viewModel.uid) {
        _payer = member;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    initTravelerOptions();
    initPayer();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddEditExpenseViewModel>();

    return Scaffold(
      appBar: TopAppBar(
        automaticallyImplyLeading: true,
        title: viewModel.expenseId == null ? "費用を追加" : "費用を編集",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        DropdownButton<TravelerBasic>(
                          value: _payer,
                          hint: Text("支払った人"),
                          items:
                              _travelersOptions.map((traveler) {
                                final displayName =
                                    traveler.traveler.profile_name ??
                                    traveler.traveler.core.email;
                                return DropdownMenuItem<TravelerBasic>(
                                  value: traveler.traveler,
                                  child: Text(displayName, maxLines: 1),
                                );
                              }).toList(),
                          onChanged: (TravelerBasic? newTraveler) {
                            setState(() {
                              _payer = newTraveler;
                            });
                          },
                        ),
                        BasicText(text: "が"),
                      ],
                    ),
                  ),
                  //キーボードを出した時にバグる。
                  Wrap(
                    spacing: 2, // 横の隙間
                    runSpacing: 8.0, // 縦の隙間
                    children:
                        _travelersOptions.asMap().entries.map((entry) {
                          final index = entry.key;
                          final traveler = entry.value;
                          final displayName =
                              traveler.traveler.profile_name ??
                              traveler.traveler.core.email;

                          return SizedBox(
                            width:
                                MediaQuery.of(context).size.width / 2 -
                                24, // 2列になるよう幅を調整
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: traveler.isChecked,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      _travelersOptions[index] = traveler
                                          .copyWith(
                                            isChecked: newValue ?? false,
                                          );
                                    });
                                  },
                                ),
                                Flexible(
                                  child: Text(
                                    displayName,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("の"),
                        Container(
                          width: 250,
                          child: BasicTextField(
                            controller: _expenseItemController,
                            hintText: "何に使ったか",
                            onChanged: (memo) {
                              _expenseItem = memo;
                            },
                          ),
                        ),
                        Text("を払って"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 250,
                          child: BasicTextField(
                            controller: _expenseController,
                            keyboardType: TextInputType.number,
                            hintText: "金額",
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              String sanitized = value.replaceFirst(
                                RegExp(r'^0+'),
                                '',
                              );
                              if (value != sanitized) {
                                // 先頭0があった場合は除去して再設定
                                _expenseController.value = TextEditingValue(
                                  text: sanitized,
                                  selection: TextSelection.collapsed(
                                    offset: sanitized.length,
                                  ),
                                );
                              }
                              setState(() {
                                _expense = int.tryParse(sanitized) ?? 0;
                              });
                            },
                          ),
                        ),
                        Text("円かかった"),
                      ],
                    ),
                  ),
                  RoundedButton(
                    title: viewModel.expenseId == null ? "費用を保存" : "費用を更新",
                    onPressed: () async {
                      final expenseResult = viewModel.createExpenseFromInput(
                        _payer,
                        _travelersOptions,
                        _expenseItem,
                        _expense,
                      );

                      if (expenseResult.isFailed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${expenseResult.error?.errorMessage}",
                            ),
                          ),
                        );
                      } else if (!expenseResult.isSuccess) {
                        /* Unknown state */
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Unknown Error. It seems to be a coding error.",
                            ),
                          ),
                        );
                      }

                      final expense = expenseResult.data;
                      if (expense == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Expense is null.　Coding error."),
                          ),
                        );
                        return;
                      }

                      final ret = await viewModel.addUpdateExpense(expense);
                      if (ret.isSuccess) {
                        /* リスナー経由で更新されるはず */
                        context.pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ret.error?.errorMessage ?? "保存に失敗しました",
                            ),
                          ),
                        );
                      }

                      //popだとExpensesScreenに戻ったときに更新されない。
                      // Navigator.pushNamed(
                      //   context,
                      //   StartScreen.id,
                      //   arguments: {"index": 1},
                      // );
                    },
                  ),
                  SizedBox(height: 80),
                  if (viewModel.expenseId != null)
                    RoundedButton(
                      title: "費用を削除",
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700], // 少し濃い赤
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        /* 削除する */
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
