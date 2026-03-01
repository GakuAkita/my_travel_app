import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/joined_groups/joined_groups_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

/// Realtime Databaseではなくなる場合も想定して作らないといけない。
class JoinedGroupsRepositoryRealtimeDb implements JoinedGroupsRepository {
  final FirebaseDatabase _database;

  JoinedGroupsRepositoryRealtimeDb({required FirebaseDatabase database})
    : _database = database;

  @override
  Future<List<String>> getJoinedGroupIds(String uid) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.user(uid).settings.joined_groups,
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
  Future<void> addJoinedGroup(String uid, String groupId) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.user(uid).settings.joined_groups,
      fromJson: (val) => val,
      toJson: (val) => val,
    );
    await service.update({groupId: true});
  }

  @override
  Future<void> removeJoinedGroup(String uid, String groupId) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.user(uid).settings.joined_group(groupId),
      fromJson: (val) => val,
      toJson: (val) => val,
    );

    await service.delete();
  }
}
