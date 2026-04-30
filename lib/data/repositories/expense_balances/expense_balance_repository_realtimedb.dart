import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/model/balance/balance_info.dart';
import 'package:my_travel_app/data/repositories/expense_balances/expense_balance_repository.dart';

import '../../services/firebase_database_service.dart';

class ExpenseBalanceRepositoryRealtimeDb implements ExpenseBalanceRepository {
  final FirebaseDatabase _database;

  ExpenseBalanceRepositoryRealtimeDb(FirebaseDatabase database)
    : _database = database;

  @override
  Future<Map<String, BalanceInfo>> getExpenseBalances({
    required String groupId,
    required String travelId,
  }) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path:
          FirebaseDatabasePaths.group(
            groupId,
          ).travels.travel(travelId).expenses.balances,
      fromJson: BalanceInfo.fromJson,
      toJson: (e) => e.toJson(),
    );
    return service.getAll();
  }
}
