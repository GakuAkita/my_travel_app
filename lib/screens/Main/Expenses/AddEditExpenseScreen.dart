import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_travel_app/CommonClass/ExpenseInfo.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/Services/FirebaseDatabaseService.dart';
import 'package:my_travel_app/components/BasicText.dart';
import 'package:my_travel_app/components/TopAppBar.dart';
import 'package:my_travel_app/screens/Main/MainScreen.dart';
import 'package:provider/provider.dart';

import '../../../CommonClass/TravelerInfo.dart';
import '../../../Store/ExpenseStore.dart';
import '../../../components/BasicTextField.dart';
import '../../../components/RoundedButton.dart';

class AddEditExpenseScreen extends StatefulWidget {
  static const String id = "add_expense_screen";

  final String? expenseId;

  AddEditExpenseScreen({this.expenseId, super.key});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  String? _shownTravelId;
  String? _shownGroupId;

  ExpenseInfo? _initialExpense;

  /* 参加者 */
  List<TravelerBasic> _allParticipants = [];

  /* グループメンバー(参加者をすべて含む) */
  List<TravelerBasic> _allGroupMembers = [];

  /* isCheckedも含んでいる */
  List<TravelerInfo> _travelersOptions = [];

  /* チェックされた人(支払われた人) */

  /**
   * 支払い用の選択肢と誰の支払いか(チェック付き)の配列を
   * 分けて2つ作らないとエラーが出る。
   * インスタンスを別にしないといけないからだと思う。
   */

  int _expense = 0;
  String _expenseItem = "";

  /// _travelersをそのままドロップダウンのリストにすると、
  /// その後で支払者のチェックボックスを切り替えた時、ドロップダウンの方にも影響が行ってしまい
  /// クラッシュする

  TravelerBasic? _payer;

  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _expenseItemController = TextEditingController();

  @override
  void dispose() {
    _expenseController.dispose();
    _expenseItemController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final expenseStore = context.read<ExpenseStore>();

    _shownGroupId = expenseStore.shownTravelBasic?.groupId;
    _shownTravelId = expenseStore.shownTravelBasic?.travelId;

    /* プロファイル名は入ってないはず、、 */
    _allParticipants =
        expenseStore.allParticipants.entries.map((entry) {
          final value = entry.value;
          return value;
        }).toList();

    _allGroupMembers =
        expenseStore.allGroupMembers.entries.map((entry) {
          final value = entry.value;
          return value;
        }).toList();

    /**
     * 全員参加ではない
     */
    if (widget.expenseId == null) {
      /* 新規作成時は全メンバーの中で参加している人だけチェック入れる */
      _travelersOptions =
          expenseStore.allGroupMembers.entries.map((entry) {
            final member = entry.value;
            final bool isParticipate = _allParticipants.any(
              (participant) => participant.uid == member.uid,
            );

            return TravelerInfo(
              uid: member.uid,
              email: member.email,
              profile_name: member.profile_name,
              isChecked: isParticipate,
            );
          }).toList();

      if (_allGroupMembers.isNotEmpty) {
        for (final traveler in _allGroupMembers) {
          if (traveler.uid == expenseStore.currentUserId) {
            _payer = traveler;
            break;
          }
        }
      }
    } else {
      /**
       * expenseIdだけ渡されて、ここで初期値を設定していく
       */
      int initialExpenseIndex = -1;
      for (int i = 0; i < expenseStore.allExpenses.length; i++) {
        if (expenseStore.allExpenses[i].id == widget.expenseId) {
          initialExpenseIndex = i;
          break;
        }
      }
      if (initialExpenseIndex == -1) {
        print(
          "Unable to find expense with id ${widget.expenseId}!! Something went wrong!!!",
        );
        /* 入力不可にしたい、、、 */
        return;
      }
      final initialExpense = expenseStore.allExpenses[initialExpenseIndex];
      _initialExpense = initialExpense;

      final TravelerBasic payerBasic = initialExpense.payer;
      for (final traveler in _allGroupMembers) {
        if (traveler.uid == payerBasic.uid) {
          _payer = traveler;
          break;
        }
      }

      _travelersOptions =
          expenseStore.allGroupMembers.entries.map((entry) {
            final value = entry.value;
            /* isCheckedを */
            return TravelerInfo(
              uid: value.uid,
              email: value.email,
              profile_name: value.profile_name,
              isChecked: initialExpense.reimbursedBy.containsKey(value.uid),
            );
          }).toList();

      _expenseController.text = initialExpense.expense.toString();
      _expense = initialExpense.expense;

      _expenseItemController.text = initialExpense.expenseItem;
      _expenseItem = initialExpense.expenseItem;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        automaticallyImplyLeading: true,
        title: widget.expenseId == null ? "費用を追加" : "費用を編集",
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
                              _allGroupMembers.map((traveler) {
                                final displayName =
                                    traveler.profile_name ?? traveler.email;
                                return DropdownMenuItem<TravelerBasic>(
                                  value: traveler,
                                  child: Text(displayName),
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
                              traveler.profile_name ?? traveler.email;

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
                    title: widget.expenseId == null ? "費用を保存" : "費用を更新",
                    onPressed: () async {
                      /* ここで値をチェックする */
                      if (_payer == null) {
                        print("_payer is empty!!");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("支払った人が選択されていません"),
                            backgroundColor:
                                Theme.of(context).colorScheme.onError,
                          ),
                        );
                        return;
                      }

                      /* isCheckedの人数をカウントして何もチェックされていなかったら弾く */
                      int cnt = 0;
                      for (final traveler in _travelersOptions) {
                        if (traveler.isChecked) {
                          cnt++;
                        }
                      }
                      if (cnt == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("誰もチェックされていません"),
                            backgroundColor:
                                Theme.of(context).colorScheme.onError,
                          ),
                        );
                        print("No one is checked!!!");
                        return;
                      }

                      /* 金額をチェックする */
                      if (_expense <= 0) {
                        print("_expenseが0以下になっている");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("金額が再入力してください:$_expense"),
                            backgroundColor:
                                Theme.of(context).colorScheme.onError,
                          ),
                        );
                        return;
                      }

                      /* 文字列をカウントしたい。 */
                      if (_expenseItem.length > 100) {
                        print("100文字を超えているのでだめです。");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("何に使ったが100文字を超えています"),
                            backgroundColor:
                                Theme.of(context).colorScheme.onError,
                          ),
                        );
                        return;
                      }

                      if (_expenseItem.isEmpty) {
                        print("何に使ったが入力されていません");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("何に使ったが入力されていません"),
                            backgroundColor:
                                Theme.of(context).colorScheme.onError,
                          ),
                        );
                        return;
                      }

                      if (_shownGroupId == null || _shownTravelId == null) {
                        print("groupId and travelId is null!!");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("旅行の情報が取得できませんでした"),
                            backgroundColor:
                                Theme.of(context).colorScheme.onError,
                          ),
                        );
                        return;
                      }
                      /* ここでセットするデータを作っていく */
                      //今払ってもらった人側は配列なのでdicに変換していく
                      Map<String, Map<String, String>> reimbursedBy = {};
                      _travelersOptions.forEach((traveler) {
                        if (traveler.isChecked == true) {
                          reimbursedBy[traveler.uid] = {
                            "uid": traveler.uid,
                            "email": traveler.email,
                          };
                        }
                      });

                      if (widget.expenseId == null) {
                        /* ここでRealtime Databaseに保存 */
                        final ref =
                            FirebaseDatabaseService.singleTravelExpensesDataRef(
                              _shownGroupId!,
                              _shownTravelId!,
                            );
                        var newRef = ref.push();
                        final generatedId = newRef.key as String;
                        final expenseInfo = ExpenseInfo(
                          id: generatedId,
                          payer: TravelerBasic(
                            uid: _payer?.uid as String,
                            email: _payer?.email as String,
                          ),
                          reimbursedBy: reimbursedBy,
                          expenseItem: _expenseItem,
                          expense: _expense,
                          createdAt: DateTime.now().toIso8601String(),
                        );

                        final dataset = expenseInfo.toMap();
                        print(dataset);
                        /* 最後に追加する */
                        newRef.set(dataset);
                      } else {
                        /* なんかもっと良い方法あるきがする */
                        final expenseInfo = ExpenseInfo(
                          id: widget.expenseId!,
                          //ここに来るときにはnullでなくなっている
                          payer: TravelerBasic(
                            uid: _payer?.uid as String,
                            email: _payer?.email as String,
                          ),
                          reimbursedBy: reimbursedBy,
                          expenseItem: _expenseItem,
                          expense: _expense,
                          createdAt:
                              _initialExpense!.createdAt, //null Pointが起こるかも。
                        );

                        final dataset = expenseInfo.toMap();

                        final ref =
                            FirebaseDatabaseService.singleTravelExpenseIdRef(
                              _shownGroupId!,
                              _shownTravelId!,
                              widget.expenseId!,
                            );
                        ref.set(dataset);
                        // ref.update()
                      }

                      //popだとExpensesScreenに戻ったときに更新されない。
                      Navigator.pushNamed(
                        context,
                        MainScreen.id,
                        arguments: {"index": 1},
                      );
                    },
                  ),
                  SizedBox(height: 80),
                  if (widget.expenseId != null)
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
                        if (_shownGroupId == null || _shownTravelId == null) {
                          print("groupId and travelId is null!!");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("旅行の情報が取得できませんでした"),
                              backgroundColor:
                                  Theme.of(context).colorScheme.onError,
                            ),
                          );
                          return;
                        }

                        final ref =
                            FirebaseDatabaseService.singleTravelExpenseIdRef(
                              _shownGroupId!,
                              _shownTravelId!,
                              widget.expenseId!,
                            );

                        await ref.remove();
                        Navigator.pushNamed(
                          context,
                          MainScreen.id,
                          arguments: {"index": 1},
                        );
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
