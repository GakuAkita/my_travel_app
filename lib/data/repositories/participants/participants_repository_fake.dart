import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/participants/participants_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

import '../../model/traveler/traveler_core/traveler_core.dart';

class ParticipantsRepositoryFake implements ParticipantsRepository {
  final FakeDatabase _database;

  ParticipantsRepositoryFake({required FakeDatabase database}) : _database = database;

  String _path(String groupId, String travelId) =>
      FirebaseDatabasePaths.group(groupId).travels.travel(travelId).travelers;

  @override
  Future<Map<String, TravelerCore>> getAllTravelers(String groupId, String travelId) async =>
      _database.getChildren(_path(groupId, travelId)).map((k, v) => MapEntry(k, TravelerCore.fromJson(v)));

  @override
  Future<void> saveAllTravelers({
    required String groupId,
    required String travelId,
    required Map<String, TravelerCore> travelers,
  }) async => _database.set(_path(groupId, travelId), travelers.map((k, v) => MapEntry(k, v.toJson())));
}
