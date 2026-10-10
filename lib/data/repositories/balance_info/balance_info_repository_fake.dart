import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/balance_info/balance_info_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

import '../../model/balance/balance_info.dart';

class BalanceInfoRepositoryFake implements BalanceInfoRepository {
  final FakeDatabase _database;

  BalanceInfoRepositoryFake({required FakeDatabase database}) : _database = database;

  @override
  Future<Map<String, BalanceInfo>> getBalanceInfo({required String groupId, required String travelId}) async =>
      _database
          .getChildren(FirebaseDatabasePaths.group(groupId).travels.travel(travelId).expenses.balances)
          .map((k, v) => MapEntry(k, BalanceInfo.fromJson(v)));
}
