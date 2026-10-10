import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/expense_balances/expense_balance_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

import '../../model/balance/balance_info.dart';

class ExpenseBalanceRepositoryFake implements ExpenseBalanceRepository {
  final FakeDatabase _database;

  ExpenseBalanceRepositoryFake({required FakeDatabase database}) : _database = database;

  @override
  Future<Map<String, BalanceInfo>> getExpenseBalances({required String groupId, required String travelId}) async =>
      _database
          .getChildren(FirebaseDatabasePaths.group(groupId).travels.travel(travelId).expenses.balances)
          .map((k, v) => MapEntry(k, BalanceInfo.fromJson(v)));
}
