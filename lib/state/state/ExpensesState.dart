import 'package:flutter/widgets.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';

import '../../data/repositories/expenses/expense_repository.dart';

/**
 * これクラス化したほうがいいか？
 */
class ExpensesState extends ChangeNotifier {
  final ExpenseRepository _expenseRepository;
  final ShownTravelSession _travelSession;

  ShownTravelBasic? _travel;

  ExpensesState({
    required ShownTravelSession travelSession,
    required ExpenseRepository expensesRepository,
  }) : _travelSession = travelSession,
       _expenseRepository = expensesRepository {
    print("ExpensesState was created");

    _travelSession.addListener(_onTravelChanged);
  }

  void _onTravelChanged() async {
    print("ExpensesState detected travel changed.");
    if (_travel == _travelSession.currentTravel) return;

    /* ここでロードし始める */
  }

  @override
  void dispose() {
    print("ExpensesState was created");
    // TODO: implement dispose
    super.dispose();
  }
}
