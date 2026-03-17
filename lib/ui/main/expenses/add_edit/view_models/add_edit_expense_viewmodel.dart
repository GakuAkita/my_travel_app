import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/core/utils/CheckShownTravelBasic.dart';
import 'package:my_travel_app/data/model/expense/expense_info.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/expense_store.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';
import 'package:my_travel_app/ui/main/expenses/add_edit/widgets/selected_traveler.dart';

import '../../../../../data/model/traveler/traveler_core/traveler_core.dart';

class AddEditExpenseViewModel extends ChangeNotifier {
  final ExpenseRepository _expenseRepository;
  final ExpenseStore _expenseStore;
  final TravelScopeStore _travelScopeStore;
  final ShownTravelSession _travelSession;
  final AppSession _appSession;
  final String? _expenseId;

  String? get expenseId => _expenseId;

  late final ExpenseInfo? _initialExpense;

  ExpenseInfo? get initialExpense => _initialExpense;

  late final List<TravelerBasic> _groupMembers;

  List<TravelerBasic> get groupMembers => _groupMembers;

  late final List<TravelerCore> _participants;

  List<TravelerCore> get participants => _participants;

  String get uid => _appSession.currentUser!.uid;

  bool _isError = false;

  bool get isError => _isError;

  AddEditExpenseViewModel({
    String? expenseId,
    required ExpenseRepository expenseRepository,
    required ExpenseStore expenseStore,
    required TravelScopeStore travelScopeStore,
    required ShownTravelSession travelSession,
    required AppSession appSession,
  }) : _expenseId = expenseId,
       _expenseRepository = expenseRepository,
       _expenseStore = expenseStore,
       _travelScopeStore = travelScopeStore,
       _travelSession = travelSession,
       _appSession = appSession {
    if (!_expenseStore.storeInitialized ||
        !_travelScopeStore.storeInitialized) {
      /* UIの通り道でブロックしているのでここに来ることはまずない */
      print("Store is not initialized!");
      _isError = true;
    }

    final groupMembersState = _travelScopeStore.allGroupMembers;
    if (groupMembersState.hasError) {
      _isError = true;
    }
    _groupMembers =
        groupMembersState.hasData
            ? groupMembersState.data!.entries
                .map((entry) => entry.value)
                .toList()
            : [];
    final participantsState = _travelScopeStore.participants;
    if (participantsState.hasError) {
      _isError = true;
    }
    _participants =
        participantsState.hasData
            ? participantsState.data!.entries
                .map((entry) => entry.value)
                .toList()
            : [];

    if (_expenseStore.allExpenses.hasError ||
        !_expenseStore.allExpenses.hasData) {
      _isError = true;
    } else {
      if (_expenseId != null) {
        /// 万が一、画面編集中にExpenseが削除されたとき、expenseIdだけだと元に戻せなくなるので
        /// initialExpenseで値を持っておく
        _initialExpense = _expenseStore.allExpenses.data![_expenseId];
      }
    }

    print("AddEditViewModel was created");
  }

  /* Validationを終えてからこれを実行する */
  /* 失敗した場合はUI側でSnackBar */
  ResultInfo<ExpenseInfo> createExpenseFromInput(
    TravelerBasic? payer,
    List<SelectedTraveler> options,
    String expenseItem,
    int expense,
  ) {
    if (payer == null) {
      print("_payer is empty!!");
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "支払った人が選択されていません"),
      );
    }

    /* isCheckedの人数をカウントして何もチェックされていなかったら弾く */
    int cnt = 0;
    for (final traveler in options) {
      if (traveler.isChecked) {
        cnt++;
      }
    }
    if (cnt == 0) {
      print("No one is checked!!!");
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "No one is checked"),
      );
    }

    /* 金額をチェックする */
    if (expense <= 0) {
      print("_expenseが0以下になっている");
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "金額が0以下になっています"));
    }

    /* 文字列をカウントしたい。 */
    if (expenseItem.length > 100) {
      print("100文字を超えているのでだめです。");
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "何に使ったが100文字を超えています"),
      );
    }

    if (expenseItem.isEmpty) {
      print("何に使ったが入力されていません");
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "何に使ったが入力されていません"),
      );
    }

    final Map<String, TravelerCore> reimbursedBy = {};
    for (final option in options) {
      if (option.isChecked) {
        reimbursedBy[option.traveler.core.uid] = option.traveler.core;
      }
    }

    final expenseInfo = ExpenseInfo(
      id: _expenseId,
      payer: payer.core,
      reimbursedBy: reimbursedBy,
      expenseItem: expenseItem,
      expense: expense,
      createdAt: _initialExpense?.createdAt,
    );

    return ResultInfo.success(data: expenseInfo);
  }

  Future<ResultInfo> addUpdateExpense(ExpenseInfo expense) async {
    final travel = _travelSession.currentTravel;
    if (travel == null || !checkIsShownTravelValid(travel).isSuccess) {
      /* ここに来るのはおかしい */
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "Invalid Travel. Coding error"),
      );
    }
    final groupId = travel.groupId!;
    final travelId = travel.travelId!;

    try {
      if (expense.id == null) {
        /* 新規追加 */
        await _expenseRepository.addExpense(groupId, travelId, expense);
      } else {
        /* 更新 */
        await _expenseRepository.updateExpense(groupId, travelId, expense);
      }
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  Future<ResultInfo> deleteExpense(String expenseId) async {
    final travel = _travelSession.currentTravel;
    if (travel == null || !checkIsShownTravelValid(travel).isSuccess) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "Invalid travel. Coding error"),
      );
    }

    final groupId = travel.groupId!;
    final travelId = travel.travelId!;

    try {
      await _expenseRepository.deleteExpense(groupId, travelId, expenseId);
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  @override
  void dispose() {
    print("AddEditExpenseViewModel(${hashCode}) was disposed");
    // TODO: implement dispose
    super.dispose();
  }
}
