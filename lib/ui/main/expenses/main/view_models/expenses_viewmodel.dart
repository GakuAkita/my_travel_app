import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/ui/core/store/expense_store.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';

import '../../../../../data/model/expense/expense_info.dart';
import '../../../../../state/session/shown_travel_session.dart';

class ExpensesViewModel extends ChangeNotifier {
  final ExpenseStore _expenseStore;
  final TravelScopeStore _travelScopeStore;
  final ShownTravelSession _travelSession;

  bool _isExpensesLoading = false;

  bool get isExpensesLoading => _isExpensesLoading;

  /* いらないか、、 */
  bool isTravelScopeLoading() {
    return _travelScopeStore.participants.isLoading ||
        _travelScopeStore.planners.isLoading ||
        _travelScopeStore.allGroupMembers.isLoading;
  }

  bool get isGroupMembersLoading => _travelScopeStore.allGroupMembers.isLoading;

  Map<String, ExpenseInfo>? _allExpenses;

  bool get expenseStoreInitialized => _expenseStore.storeInitialized;

  bool get travelScopeStoreInitialized => _travelScopeStore.storeInitialized;

  List<ExpenseInfo> allExpensesList({bool sort = true}) {
    if (_allExpenses == null) {
      return [];
    }

    /* createdAtで並べる。引数で */
    final listedExpenses = _allExpenses!.values.toList();
    if (sort) {
      listedExpenses.sort((a, b) {
        final aTime = a.createdAt;
        final bTime = b.createdAt;

        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1; // aを後ろへ
        if (bTime == null) return -1; // bを後ろへ

        return bTime.compareTo(aTime);
      });
    }
    return listedExpenses;
  }

  Map<String, TravelerBasic> _allGroupMembers = {};

  Map<String, TravelerBasic> get allGroupMembers => _allGroupMembers;

  ShownTravelBasic? get currentTravel => _travelSession.currentTravel;

  /**
   * 旅行がスイッチされるたびにViewModelが再生成される。
   */
  ExpensesViewModel({
    required ExpenseStore expenseStore,
    required TravelScopeStore travelScopeStore,
    required ShownTravelSession travelSession,
  }) : _expenseStore = expenseStore,
       _travelScopeStore = travelScopeStore,
       _travelSession = travelSession {
    /**
     * UI側でviewModel.travelSession.currentTravelと書いてしまうと、
     * UIがTravelSessionに直接依存することになる。それはよくない。
     * コピーして、addListenersでsyncする。
     *  */
    print("ExpenseViewModel was created code=${hashCode}");

    _expenseStore.addListener(_expenseSync);
    _travelScopeStore.addListener(_travelsSync);
  }

  void _expenseSync() {
    try {
      final expensesDataState = _expenseStore.allExpenses;
      if (expensesDataState.isLoading) {
        /* ずっとローディング状態になるのはちょっと怖いな。どこかでタイムアウトできないかな */
        _isExpensesLoading = true;
      } else if (expensesDataState.hasError) {
        _isExpensesLoading = false;
        /* エラー内容をUI側に伝えたい。 */
        print("expenseStore error=${expensesDataState.error?.errorMessage}");
      } else if (expensesDataState.hasData) {
        print("There are expenses");
        _isExpensesLoading = false;
        _allExpenses = _expenseStore.allExpenses.data;
      } else {
        /* エラーでもないけどdataがnull?? */
        _isExpensesLoading = false;
        print("this might be the coding error???");
      }
    } finally {
      notifyListeners();
    }
  }

  /* 旅行で必要なデータのsync */
  void _travelsSync() {
    try {
      final groupMembersDataState = _travelScopeStore.allGroupMembers;
      final plannersDataState = _travelScopeStore.planners;
      final participantsDataState = _travelScopeStore.participants;

      if (groupMembersDataState.hasData) {
        _allGroupMembers = groupMembersDataState.data!;
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshExpenses({bool isLoadingNotify = true}) async {
    await _expenseStore.refreshExpenses(
      isLoadingNotify: isLoadingNotify,
      isLastNotify: true,
    );
  }

  @override
  void dispose() {
    _expenseStore.removeListener(_expenseSync);
    _travelScopeStore.removeListener(_travelsSync);
    print("ExpenseViewModel was disposed. code=${hashCode}");
    // TODO: implement dispose
    super.dispose();
  }
}
