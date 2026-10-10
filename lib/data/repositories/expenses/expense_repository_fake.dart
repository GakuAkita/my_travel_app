import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_cloud_functions.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

import '../../model/expense/expense_info.dart';

class ExpenseRepositoryFake implements ExpenseRepository {
  final FakeDatabase _database;

  ExpenseRepositoryFake({required FakeDatabase database}) : _database = database;

  ExpensesPath _expenses(String groupId, String travelId) =>
      FirebaseDatabasePaths.group(groupId).travels.travel(travelId).expenses;

  Map<String, ExpenseInfo> _toExpenses(dynamic value) {
    if (value is! Map) return {};
    return value.map((key, json) => MapEntry(key as String, ExpenseInfo.fromJson(Map<String, dynamic>.from(json))));
  }

  @override
  Stream<Map<String, ExpenseInfo>> watchExpenses(String groupId, String travelId) =>
      _database.watch(_expenses(groupId, travelId).data, _toExpenses);

  @override
  Future<Map<String, ExpenseInfo>> getAllExpenses(String groupId, String travelId) async =>
      _toExpenses(_database.get(_expenses(groupId, travelId).data));

  @override
  Future<ExpenseInfo> addExpense(String groupId, String travelId, ExpenseInfo expense) async {
    final key = _database.pushKey();
    final added = expense.copyWith(id: key, createdAt: DateTime.now().millisecondsSinceEpoch);
    _database.set(_expenses(groupId, travelId).singleData(key), added.toJson());
    FakeCloudFunctions.onExpenseDataChange(_database, groupId, travelId);
    return added;
  }

  @override
  Future<void> updateExpense(String groupId, String travelId, ExpenseInfo expense) async {
    if (expense.id == null) {
      throw AppException("Expense id is null. This is the coding error.");
    }
    _database.update(_expenses(groupId, travelId).singleData(expense.id!), expense.toJson());
    FakeCloudFunctions.onExpenseDataChange(_database, groupId, travelId);
  }

  @override
  Future<void> deleteExpense(String groupId, String travelId, String expenseId) async {
    _database.remove(_expenses(groupId, travelId).singleData(expenseId));
    FakeCloudFunctions.onExpenseDataChange(_database, groupId, travelId);
  }
}
