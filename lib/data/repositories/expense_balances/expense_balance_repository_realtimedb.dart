import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/repositories/expense_balances/expense_balance_repository.dart';

import '../../../CommonClass/BalanceInfo.dart';

class ExpenseBalanceRepositoryRealtimeDb implements ExpenseBalanceRepository {
  final FirebaseDatabase _database;

  ExpenseBalanceRepositoryRealtimeDb(FirebaseDatabase database)
    : _database = database;

  @override
  Future<Map<String, BalancesInfo>> getExpenseBalances({
    required String groupId,
    required String travelId,
  }) async {
    //final service = FirebaseDatabaseService(database: _database, path: path, fromJson: (), toJson: toJson)
    return {};
  }
}
