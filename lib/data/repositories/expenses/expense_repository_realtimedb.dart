import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

import '../../model/expense/expense_info.dart';

class ExpenseRepositoryRealtimeDb implements ExpenseRepository {
  final FirebaseDatabase _firebaseDatabase;

  ExpenseRepositoryRealtimeDb({required FirebaseDatabase firebaseDatabase})
    : _firebaseDatabase = firebaseDatabase;

  FirebaseDatabaseService<ExpenseInfo> _service(
    String groupId,
    String travelId, {
    String? expenseId /* idを渡したときは単一ノード */,
  }) {
    String _path = "";
    if (expenseId == null) {
      _path =
          FirebaseDatabasePaths.group(
            groupId,
          ).travels.travel(travelId).expenses.data;
    } else {
      _path = FirebaseDatabasePaths.group(
        groupId,
      ).travels.travel(travelId).expenses.singleData(expenseId);
    }

    return FirebaseDatabaseService<ExpenseInfo>(
      database: _firebaseDatabase,
      path: _path,
      fromJson: ExpenseInfo.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  @override
  Stream<Map<String, ExpenseInfo>> watchExpenses(
    String groupId,
    String travelId,
  ) {
    //print("****** Stream all was called! ******");
    final service = _service(groupId, travelId);
    return service.streamAll();
  }

  @override
  Future<Map<String, ExpenseInfo>> getAllExpenses(
    String groupId,
    String travelId,
  ) async {
    final service = _service(groupId, travelId);
    final expenses = await service.getAll();
    return expenses;
  }

  @override
  Future<ExpenseInfo> addExpense(
    String groupId,
    String travelId,
    ExpenseInfo expense,
  ) async {
    final service = _service(groupId, travelId);
    final added = await service.addAuto(expense);
    return added;
  }

  @override
  Future<void> updateExpense(
    String groupId,
    String travelId,
    ExpenseInfo expense,
  ) async {
    if (expense.id == null) {
      throw AppException("Expense id is null. This is the coding error.");
    }
    final service = _service(groupId, travelId, expenseId: expense.id!);
    await service.update(expense);
  }

  @override
  Future<void> deleteExpense(
    String groupId,
    String travelId,
    String expenseId,
  ) async {
    final service = _service(groupId, travelId, expenseId: expenseId);
    await service.delete();
  }
}
