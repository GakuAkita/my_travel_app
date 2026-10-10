import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/data/repositories/group_creator/group_creator_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

class GroupCreatorRepositoryFake implements GroupCreatorRepository {
  final FakeDatabase _database;

  GroupCreatorRepositoryFake({required FakeDatabase database}) : _database = database;

  @override
  Future<TravelerCore?> getGroupCreator(String groupId) async {
    final json = _database.get(FirebaseDatabasePaths.group(groupId).creator);
    if (json == null) return null;
    return TravelerCore.fromJson(Map<String, dynamic>.from(json));
  }

  @override
  Future<void> setGroupCreator(String groupId, TravelerCore travelerCore) async =>
      _database.set(FirebaseDatabasePaths.group(groupId).creator, travelerCore.toJson());
}
