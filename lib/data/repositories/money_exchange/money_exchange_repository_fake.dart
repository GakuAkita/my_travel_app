import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/money_exchange/money_exchange_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

import '../../model/money_exchange/money_exchange.dart';

class MoneyExchangeRepositoryFake implements MoneyExchangeRepository {
  final FakeDatabase _database;

  MoneyExchangeRepositoryFake({required FakeDatabase database}) : _database = database;

  @override
  Future<String?> getMoneyExchangeLastUpdated({required String groupId, required String travelId}) async =>
      _database.get(FirebaseDatabasePaths.group(groupId).travels.travel(travelId).expenses.lastUpdated) as String?;

  @override
  Future<List<MoneyExchange>> getMoneyExchangeData({required String groupId, required String travelId}) async =>
      _database
          .getList(FirebaseDatabasePaths.group(groupId).travels.travel(travelId).expenses.exchanges)
          .map(MoneyExchange.fromJson)
          .toList();
}
