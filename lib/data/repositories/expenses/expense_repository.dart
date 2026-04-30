import '../../model/expense/expense_info.dart';

abstract class ExpenseRepository {
  /* 全体が全部流れていくる。毎回全体更新 */
  Stream<Map<String, ExpenseInfo>> watchExpenses(
    String groupId,
    String travelId,
  );

  Future<Map<String, ExpenseInfo>> getAllExpenses(
    String groupId,
    String travelId,
  );

  Future<ExpenseInfo> addExpense(
    String groupId,
    String travelId,
    ExpenseInfo expense,
  );

  Future<void> updateExpense(
    String groupId,
    String travelId,
    ExpenseInfo expense,
  );

  Future<void> deleteExpense(
    String groupId,
    String travelId,
    String expenseId /* Stringの法が良いのか、ExpenseInfoがいいのか */,
  );
}
