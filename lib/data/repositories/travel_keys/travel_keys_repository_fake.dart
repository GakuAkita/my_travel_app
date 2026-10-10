import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/travel_keys/travel_keys_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

class TravelKeysRepositoryFake implements TravelKeysRepository {
  final FakeDatabase _database;

  TravelKeysRepositoryFake({required FakeDatabase database}) : _database = database;

  @override
  Future<List<String>> getGroupTravelIds(String groupId) async {
    final value = _database.get(FirebaseDatabasePaths.groupKey(groupId).path);
    if (value is! Map) return [];
    return value.keys.cast<String>().toList();
  }

  @override
  Future<void> addGroupTravelId(String groupId, String travelId) async =>
      _database.set(FirebaseDatabasePaths.groupKey(groupId).travel(travelId), true);

  @override
  Future<void> removeGroupTravelId(String groupId, String travelId) async =>
      _database.remove(FirebaseDatabasePaths.groupKey(groupId).travel(travelId));

  @override
  Future<void> removeAllGroupTravelIds(String groupId) async =>
      _database.remove(FirebaseDatabasePaths.groupKey(groupId).path);
}
