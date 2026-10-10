import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/joined_groups/joined_groups_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

class JoinedGroupsRepositoryFake implements JoinedGroupsRepository {
  final FakeDatabase _database;

  JoinedGroupsRepositoryFake({required FakeDatabase database}) : _database = database;

  @override
  Future<List<String>> getJoinedGroupIds(String uid) async {
    final value = _database.get(FirebaseDatabasePaths.user(uid).settings.joined_groups);
    if (value is! Map) return [];
    return value.keys.cast<String>().toList();
  }

  @override
  Future<void> addJoinedGroup(String uid, String groupId) async =>
      _database.set(FirebaseDatabasePaths.user(uid).settings.joined_group(groupId), true);

  @override
  Future<void> removeJoinedGroup(String uid, String groupId) async =>
      _database.remove(FirebaseDatabasePaths.user(uid).settings.joined_group(groupId));
}
