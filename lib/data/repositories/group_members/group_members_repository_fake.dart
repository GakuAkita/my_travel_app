import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

class GroupMembersRepositoryFake implements GroupMembersRepository {
  final FakeDatabase _database;

  GroupMembersRepositoryFake({required FakeDatabase database}) : _database = database;

  @override
  Future<Map<String, TravelerCore>> getAllGroupMembers(String groupId) async => _database
      .getChildren(FirebaseDatabasePaths.group(groupId).members)
      .map((k, v) => MapEntry(k, TravelerCore.fromJson(v)));

  @override
  Future<void> setGroupMembers(String groupId, Map<String, TravelerCore> members) async => _database.set(
    FirebaseDatabasePaths.group(groupId).members,
    members.map((k, v) => MapEntry(k, v.toJson())),
  );
}
