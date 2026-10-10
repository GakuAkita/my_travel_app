import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/data/repositories/planners/planners_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

class PlannersRepositoryFake implements PlannersRepository {
  final FakeDatabase _database;

  PlannersRepositoryFake({required FakeDatabase database}) : _database = database;

  String _path(String groupId, String travelId) =>
      FirebaseDatabasePaths.group(groupId).travels.travel(travelId).planners;

  @override
  Future<Map<String, TravelerCore>> getAllPlanners(String groupId, String travelId) async =>
      _database.getChildren(_path(groupId, travelId)).map((k, v) => MapEntry(k, TravelerCore.fromJson(v)));

  @override
  Future<void> savePlanners(String groupId, String travelId, Map<String, TravelerCore> planners) async =>
      _database.set(_path(groupId, travelId), planners.map((k, v) => MapEntry(k, v.toJson())));
}
