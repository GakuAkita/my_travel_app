import 'package:flutter/widgets.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';

import '../../data/repositories/expenses/expense_repository.dart';

class ExpensesState extends ChangeNotifier {
  final ExpenseRepository _expenseRepository;

  ShownTravelBasic? _travel;

  ExpensesState({required ExpenseRepository expensesRepository})
    : _expenseRepository = expensesRepository {
    print("ExpensesState was created");
  }

  @override
  void dispose() {
    print("ExpensesState was created");
    // TODO: implement dispose
    super.dispose();
  }
}
