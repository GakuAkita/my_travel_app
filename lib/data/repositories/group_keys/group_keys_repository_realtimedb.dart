import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/group_keys/group_keys_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

class GroupKeysRepositoryRealtimeDb implements GroupKeysRepository {
  final FirebaseDatabase _database;

  GroupKeysRepositoryRealtimeDb({required FirebaseDatabase database})
    : _database = database;

  @override
  Future<List<String>> getGroupTravelIds(String groupId) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.groupKey(groupId).path,
      fromJson: (val) => val.keys.toList(),
      toJson: (list) {
        Map<String, bool> raw = {};
        for (final key in list) {
          raw[key] = true;
        }
        return raw;
      },
    );
    final ids = await service.get();
    if (ids == null) {
      return [];
    } else {
      return ids;
    }
  }

  @override
  Future<void> addGroupTravelId(String groupId, String travelId) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.groupKey(groupId).travel(travelId),
      fromJson: (val) => val,
      toJson: (val) => val,
    );
    await service.setValue(true);
  }

  @override
  Future<void> removeGroupTravelId(String groupId, String travelId) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.groupKey(groupId).travel(travelId),
      fromJson: (val) => val,
      toJson: (val) => val,
    );
    await service.delete();
  }
}
