import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/repositories/expenses/expense_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

import '../../model/expense/expense_info.dart';

class ExpenseRepositoryRealtimeDb implements ExpenseRepository {
  final FirebaseDatabase _firebaseDatabase;
  final String _userId;
  late final FirebaseDatabaseService _databaseService;

  ExpenseRepositoryRealtimeDb({
    required FirebaseDatabase firebaseDatabase,
    required String userId,
  }) : _firebaseDatabase = firebaseDatabase,
       _userId = userId {
    _databaseService = FirebaseDatabaseService(
      database: _firebaseDatabase,
      path: "users/$_userId/expenses",
      fromJson: ExpenseInfo.fromJson,
      toJson: (expense) => expense.toJson(),
    );
  }

  @override
  Future<Map<String, ExpenseInfo>> getAllExpenses(
    String groupId,
    String travelId,
  ) async {
    // TODO: implement getAllExpenses
    throw AppException("Not implemented getAllExpenses");
  }

  @override
  Future<ExpenseInfo> addExpense(
    String groupId,
    String travelId,
    ExpenseInfo expense,
  ) async {
    throw AppException("Not implemented addExpense");
  }

  @override
  Future<void> updateExpense(
    String groupId,
    String travelId,
    ExpenseInfo expense,
  ) async {
    throw AppException("Not implemented updateExpense");
  }

  @override
  Future<void> deleteExpense(
    String groupId,
    String travelId,
    String expenseId,
  ) async {
    throw AppException("Not implemented deleteExpense");
  }
}
