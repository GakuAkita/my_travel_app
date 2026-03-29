import 'package:flutter/widgets.dart';
import 'package:my_travel_app/data/model/expense/expense_info.dart';
import 'package:my_travel_app/ui/core/store/expense_store.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';

class ExpenseResultViewModel extends ChangeNotifier {
  final ExpenseStore _expenseStore;
  final TravelScopeStore _travelScopeStore;

  bool _isExpensesUpdated = false;

  bool get isExpensesUpdated => _isExpensesUpdated;

  ExpenseResultViewModel({
    required ExpenseStore expenseStore,
    required TravelScopeStore travelScopeStore,
  }) : _expenseStore = expenseStore,
       _travelScopeStore = travelScopeStore {
    print("ExpenseResultViewModel Created. $hashCode");

    _expenseStore.addListener(_onExpensesUpdated);
  }

  void _onExpensesUpdated() {
    print("ExpenseResultViewModel _onExpensesUpdated called");
    _isExpensesUpdated = true;
    notifyListeners();
  }

  List<ExpenseInfo> allExpensesList() {
    if (_expenseStore.allExpenses.hasData) {
      return _expenseStore.allExpenses.data!.entries
          .map((entry) => entry.value)
          .toList();
    } else {
      return [];
    }
  }

  @override
  void dispose() {
    print("dispose ExpenseResultViewModel $hashCode");
    // TODO: implement dispose
    super.dispose();
  }
}
