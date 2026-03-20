import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/ui/core/store/expense_store.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';

import '../../../../../data/model/expense/expense_info.dart';
import '../../../../../state/session/shown_travel_session.dart';

class ExpensesViewModel extends ChangeNotifier {
  final ExpenseStore _expenseStore;
  final TravelScopeStore _travelScopeStore;
  final ShownTravelSession _travelSession;

  bool get isExpensesLoading => _expenseStore.allExpenses.isLoading;

  bool get isGroupMembersLoading => _travelScopeStore.allGroupMembers.isLoading;

  bool get isParticipantsLoading => _travelScopeStore.participants.isLoading;

  bool get isPlannerLoading => _travelScopeStore.planners.isLoading;

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

  Map<String, TravelerBasic>? _allGroupMembers;

  Map<String, TravelerBasic>? get allGroupMembers => _allGroupMembers;

  Map<String, TravelerCore>? _allPlanners;

  Map<String, TravelerCore>? get allPlanners => _allPlanners;

  Map<String, TravelerCore>? _allParticipants;

  Map<String, TravelerCore>? get allParticipants => _allParticipants;

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

    /* subscriptionして追加があったら更新する */
  }

  void _expenseSync() {
    try {
      final expensesDataState = _expenseStore.allExpenses;
      if (expensesDataState.hasError) {
        /* エラー内容をUI側に伝えたい。 */
        print("expenseStore error=${expensesDataState.error?.errorMessage}");
      } else if (expensesDataState.hasData) {
        print("There are expenses");
        _allExpenses = _expenseStore.allExpenses.data!;
      } else {
        /* エラーでもないけどdataがnull?? */
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

      if (groupMembersDataState.hasError) {
        print(
          "groupMembers error=${groupMembersDataState.error?.errorMessage}",
        );
      } else if (groupMembersDataState.hasData) {
        print("There are group members!");
        _allGroupMembers = groupMembersDataState.data;
      } else {
        /// グループメンバー、参加者、プランナー等々並列でロードするので
        /// どれからのローディングのnotifyでここに来てしまう。
        if (_travelScopeStore.storeInitialized) {
          print("This might be coding error?? group members");
        }
      }

      if (plannersDataState.hasError) {
        print("planners error=${plannersDataState.error?.errorMessage}");
      } else if (plannersDataState.hasData) {
        print("There are planners!");
        _allPlanners = plannersDataState.data;
      } else {
        if (_travelScopeStore.storeInitialized) {
          print("This might be coding error?? planners");
        }
      }

      if (participantsDataState.hasError) {
        print(
          "participants error=${participantsDataState.error?.errorMessage}",
        );
      } else if (participantsDataState.hasData) {
        print("There are participants");
        _allParticipants = participantsDataState.data;
      } else {
        if (_travelScopeStore.storeInitialized) {
          print("This might be coding error??? participants");
        }
      }
    } finally {
      notifyListeners();
    }
  }

  void refreshExpenses({bool isLoadingNotify = true}) async {
    _expenseStore.refreshExpenses(isLoadingNotify: isLoadingNotify);
  }

  Future<void> refreshParticipants({bool isLoadingNotify = true}) async {
    await _travelScopeStore.refreshParticipants(
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
