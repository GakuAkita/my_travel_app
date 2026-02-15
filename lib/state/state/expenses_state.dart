import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ExpenseInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
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

  Map<String, ExpenseInfo> _allExpenses = {};

  Map<String, ExpenseInfo> get allExpenses => _allExpenses;

  ExpensesState({
    required ShownTravelSession travelSession,
    required ExpenseRepository expensesRepository,
  }) : _travelSession = travelSession,
       _expenseRepository = expensesRepository {
    print("ExpensesState was created");

    _travelSession.addListener(_onTravelChanged);
  }

  void _onTravelChanged() async {
    if (_travel == null && _travelSession.initialized) {}

    if (_travel == _travelSession.currentTravel &&
        _travelSession.initialized == true) {
      print("shown travel isn't different from ${_travel?.toJson()}");
      return;
    }
    /* ここでロードし始める */
  }

  Future<ResultInfo<void>> getAllExpensesWithNotify() async {
    final result = await getAllExpenses();
    if (result.isSuccess) {
      _allExpenses = result.data!;
      notifyListeners();
    }
    return result.toVoid();
  }

  Future<ResultInfo<Map<String, ExpenseInfo>>> getAllExpenses() async {
    final groupId = _travel!.groupId!;
    final travelId = _travel!.travelId!;
    final result = await _expenseRepository.getAllExpenses(groupId, travelId);
    return result;
  }

  @override
  void dispose() {
    print("ExpensesState was disposed");
    _travelSession.removeListener(_onTravelChanged);
    // TODO: implement dispose
    super.dispose();
  }
}
