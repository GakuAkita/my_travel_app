import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/groups/groups_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

class GroupsRepositoryRealtimeDb implements GroupsRepository {
  final FirebaseDatabase _database;

  GroupsRepositoryRealtimeDb({required FirebaseDatabase database})
    : _database = database;

  @override
  Future<void> deleteGroupsRepository(String groupId) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.groups.toString(),
      fromJson: (e) => e,
      toJson: (e) => e,
    );
    await service.delete();
  }
}
