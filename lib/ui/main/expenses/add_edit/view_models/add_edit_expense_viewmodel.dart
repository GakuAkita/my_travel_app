import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/data/model/expense/expense_info.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/ui/core/store/expense_store.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';

import '../../../../../data/model/traveler/traveler_core/traveler_core.dart';

class AddEditExpenseViewModel extends ChangeNotifier {
  final ExpenseRepository _expenseRepository;
  final ExpenseStore _expenseStore;
  final TravelScopeStore _travelScopeStore;
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
    required AppSession appSession,
  }) : _expenseId = expenseId,
       _expenseRepository = expenseRepository,
       _expenseStore = expenseStore,
       _travelScopeStore = travelScopeStore,
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
  }

  @override
  void dispose() {
    print("AddEditExpenseViewModel(${hashCode}) was disposed");
    // TODO: implement dispose
    super.dispose();
  }
}
