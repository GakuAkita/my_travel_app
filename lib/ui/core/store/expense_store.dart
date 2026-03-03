import 'package:flutter/foundation.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';

class ExpenseStore extends ChangeNotifier {
  final ExpenseRepository _expenseRepository;

  ExpenseStore({required ExpenseRepository expenseRepository})
    : _expenseRepository = expenseRepository {
    print("ExpenseStore was created. hashCode=${hashCode}");
  }

  @override
  void dispose() {
    print("ExpenseStore was disposed. hashCode=${hashCode}");
    // TODO: implement dispose
    super.dispose();
  }
}
