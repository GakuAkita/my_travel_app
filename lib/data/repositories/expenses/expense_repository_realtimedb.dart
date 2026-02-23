import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

import '../../model/expense/expense_info.dart';

class ExpenseRepositoryRealtimeDb implements ExpenseRepository {
  final FirebaseDatabase _firebaseDatabase;
  final String _userId;

  ExpenseRepositoryRealtimeDb({
    required FirebaseDatabase firebaseDatabase,
    required String userId,
  })
      : _firebaseDatabase = firebaseDatabase,
        _userId = userId {}

  FirebaseDatabaseService<ExpenseInfo> _service(String groupId,
      String travelId,
      {String? expenseId} /* ifを渡したときは単一ノード */,) {
    String _path = "";
    if (expenseId == null) {
      _path =
          FirebaseDatabasePaths
              .group(
            groupId,
          )
              .travels
              .travel(travelId)
              .expenses
              .data;
    } else {
      _path = FirebaseDatabasePaths
          .group(
        groupId,
      )
          .travels
          .travel(travelId)
          .expenses
          .singleData(expenseId);
    }

    return FirebaseDatabaseService<ExpenseInfo>(
      database: _firebaseDatabase,
      path: _path,
      fromJson: ExpenseInfo.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  @override
  Future<Map<String, ExpenseInfo>> getAllExpenses(String groupId,
      String travelId,) async {
    final service = _service(groupId, travelId);
    final expenses = await service.getAll();
    return expenses;
  }

  @override
  Future<ExpenseInfo> addExpense(String groupId,
      String travelId,
      ExpenseInfo expense,) async {
    final service = _service(groupId, travelId);
    final added = await service.addAuto(expense);
    return added;
  }

  @override
  Future<void> updateExpense(String groupId,
      String travelId,
      ExpenseInfo expense,) async {
    if (expense.id == null) {
      throw AppException("Expense id is null. This is the coding error.");
    }
    final service = _service(groupId, travelId, expenseId: expense.id!);
    final updated = await service.update(expense);
    throw AppException("Not implemented updateExpense");
  }

  @override
  Future<void> deleteExpense(String groupId,
      String travelId,
      String expenseId,) async {
    throw AppException("Not implemented deleteExpense");
  }
}
