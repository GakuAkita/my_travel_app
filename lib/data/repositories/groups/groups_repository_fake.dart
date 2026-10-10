import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/groups/groups_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

class GroupsRepositoryFake implements GroupsRepository {
  final FakeDatabase _database;

  GroupsRepositoryFake({required FakeDatabase database}) : _database = database;

  @override
  Future<void> deleteGroupsRepository(String groupId) async =>
      _database.remove(FirebaseDatabasePaths.group(groupId).path);
}
