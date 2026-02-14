import 'package:my_travel_app/CommonClass/ExpenseInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';

abstract class ExpenseRepository {
  Future<ResultInfo<Map<String, ExpenseInfo>>> getAllExpenses(
    String groupId,
    String travelId,
  );

  Future<ResultInfo<ExpenseInfo>> addExpense(
    String groupId,
    String travelId,
    ExpenseInfo expense,
  );

  Future<ResultInfo<void>> updateExpense(
    String groupId,
    String travelId,
    ExpenseInfo expense,
  );

  Future<ResultInfo<void>> deleteExpense(
    String groupId,
    String travelId,
    String expenseId /* Stringの法が良いのか、ExpenseInfoがいいのか */,
  );
}
