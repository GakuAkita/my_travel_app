import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/travel/travel_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

import '../../../core/exceptions/app_exception.dart';

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
  Future<String> addTravelId({
    required String groupId,
    required String travelName,
  }) async {
    final newId =
        _database
            .ref(FirebaseDatabasePaths.group(groupId).travels.path)
            .push()
            .key;
    if (newId == null) {
      throw AppException("Failed to add new travel id");
    }

    // TODO: implement addTravelId
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.group(groupId).travels.travel(newId).name,
      fromJson: (e) => e,
      toJson: (e) => e,
    );
    await service.setValue(travelName);
    return newId;
  }

  @override
  Future<void> deleteTravel({
    required String groupId,
    required String travelId,
  }) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path:
          FirebaseDatabasePaths.group(
            groupId,
          ).travels.travel(travelId).toString(),
      fromJson: (e) => e,
      toJson: (e) => e,
    );
    await service.delete();
    return;
  }
}
