import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/money_exchange/money_exchange_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

import '../../model/money_exchange/money_exchange.dart';

class MoneyExchangeRepositoryRealtimeDb implements MoneyExchangeRepository {
  FirebaseDatabase _database;

  MoneyExchangeRepositoryRealtimeDb({required FirebaseDatabase database})
    : _database = database;

  @override
  Future<String?> getMoneyExchangeLastUpdated({
    required String groupId,
    required String travelId,
  }) {
    final service = FirebaseDatabaseService(
      database: _database,
      path:
          FirebaseDatabasePaths.group(
            groupId,
          ).travels.travel(travelId).expenses.lastUpdated,
      fromJson: (e) => e,
      toJson: (e) => e,
    );
    return service.getValue();
  }

  @override
  Future<List<MoneyExchange>> getMoneyExchangeData({
    required String groupId,
    required String travelId,
  }) {
    final service = FirebaseDatabaseService(
      database: _database,
      path:
          FirebaseDatabasePaths.group(
            groupId,
          ).travels.travel(travelId).expenses.exchanges,
      fromJson: MoneyExchange.fromJson,
      toJson: (e) => e.toJson(),
    );

    return service.getList();
  }
}
