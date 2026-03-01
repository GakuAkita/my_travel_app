import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/travel/travel_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

class TravelRepositoryRealtimeDb implements TravelRepository {
  final FirebaseDatabase _database;

  TravelRepositoryRealtimeDb({required FirebaseDatabase database})
    : _database = database;

  @override
  Future<String> getTravelName({
    required String groupId,
    required String travelId,
  }) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.group(groupId).travels.travel(travelId).name,
      fromJson: (val) => val,
      toJson: (val) => val,
    );

    return await service.getValue();
  }

  @override
  Future<void> setTravelName({
    required String groupId,
    required String travelId,
    required String travelName,
  }) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.group(groupId).travels.travel(travelId).name,
      fromJson: (val) => val,
      toJson: (val) => val,
    );

    await service.setValue(travelName);
  }
}
