import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';

import '../../../CommonClass/ExpenseInfo.dart';
import '../../../CommonClass/ResultInfo.dart';

class ExpenseRepositoryRealtimeDb implements ExpenseRepository {
  @override
  Future<ResultInfo<Map<String, ExpenseInfo>>> getAllExpenses(
    String groupId,
    String travelId,
  ) async {
    // TODO: implement getAllExpenses
    print("Not Implemented!");
    return ResultInfo.success();
  }

  @override
  Future<ResultInfo<ExpenseInfo>> addExpense(
    String groupId,
    String travelId,
    ExpenseInfo expense,
  ) async {
    print("Not Implemented");
    return ResultInfo.success();
  }

  @override
  Future<ResultInfo<void>> updateExpense(
    String groupId,
    String travelId,
    ExpenseInfo expense,
  ) async {
    print("Not Implemented");
    return ResultInfo.success();
  }

  @override
  Future<ResultInfo<void>> deleteExpense(
    String groupId,
    String travelId,
    String expenseId,
  ) async {
    print("Not Implemented");
    return ResultInfo.success();
  }
}
