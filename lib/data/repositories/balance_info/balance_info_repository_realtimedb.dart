import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/balance_info/balance_info_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

import '../../model/balance/balance_info.dart';

class BalanceInfoRepositoryRealtimeDb implements BalanceInfoRepository {
  final FirebaseDatabase _database;

  BalanceInfoRepositoryRealtimeDb({required FirebaseDatabase database})
    : _database = database;

  @override
  Future<Map<String, BalanceInfo>> getBalanceInfo({
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
    return await service.getAll();
  }
}
