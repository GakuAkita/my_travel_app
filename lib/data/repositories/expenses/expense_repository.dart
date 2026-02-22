import '../../model/expense/expense_info.dart';

abstract class ExpenseRepository {
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
