import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/travel/travel_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

class TravelRepositoryFake implements TravelRepository {
  final FakeDatabase _database;

  TravelRepositoryFake({required FakeDatabase database}) : _database = database;

  @override
  Future<String> getTravelName({required String groupId, required String travelId}) async =>
      _database.get(FirebaseDatabasePaths.group(groupId).travels.travel(travelId).name) as String;

  @override
  Future<String> addTravelId({required String groupId, required String travelName}) async {
    final newId = _database.pushKey();
    _database.set(FirebaseDatabasePaths.group(groupId).travels.travel(newId).name, travelName);
    return newId;
  }

  @override
  Future<void> deleteTravel({required String groupId, required String travelId}) async =>
      _database.remove(FirebaseDatabasePaths.group(groupId).travels.travel(travelId).path);
}
