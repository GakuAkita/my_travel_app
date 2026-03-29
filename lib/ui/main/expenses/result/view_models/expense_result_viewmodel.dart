import 'package:flutter/widgets.dart';
import 'package:my_travel_app/ui/core/store/expense_store.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';

class ExpenseResultViewModel extends ChangeNotifier {
  final ExpenseStore _expenseStore;
  final TravelScopeStore _travelScopeStore;

  bool _isExpensesUpdated = false;

  bool get isExpensesUpdated => _isExpensesUpdated;

  List<Expense>

  ExpenseResultViewModel({
    required ExpenseStore expenseStore,
    required TravelScopeStore travelScopeStore,
  })
      : _expenseStore = expenseStore,
        _travelScopeStore = travelScopeStore {
    print("ExpenseResultViewModel Created. $hashCode");

    _expenseStore.addListener(_onExpensesUpdated);
  }

  void _onExpensesUpdated() {
    print("ExpenseResultViewModel _onExpensesUpdated called");
    _isExpensesUpdated = true;
    notifyListeners();
  }

  @override
  void dispose() {
    print("dispose ExpenseResultViewModel $hashCode");
    // TODO: implement dispose
    super.dispose();
  }
}
