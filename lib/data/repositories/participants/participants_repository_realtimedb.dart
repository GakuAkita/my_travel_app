import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/data/repositories/participants/participants_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

class ParticipantsRepositoryRealtimeDb implements ParticipantsRepository {
  final FirebaseDatabase _firebaseDatabase;

  ParticipantsRepositoryRealtimeDb({
    required FirebaseDatabase firebaseDatabase,
    required String userId,
  }) : _firebaseDatabase = firebaseDatabase;

  FirebaseDatabaseService<TravelerCore> _service(
    String groupId,
    String travelId,
  ) {
    return FirebaseDatabaseService(
      database: _firebaseDatabase,
      path:
          FirebaseDatabasePaths.group(
            groupId,
          ).travels.travel(travelId).travelers,
      fromJson: TravelerCore.fromJson,
      toJson: (val) => val.toJson(),
    );
  }

  @override
  Future<Map<String, TravelerCore>> getAllTravelers(
    String groupId,
    String travelId,
  ) async {
    final service = _service(groupId, travelId);
    final travelers = await service.getAll();
    return travelers;
  }

  @override
  Future<void> saveAllTravelers({
    required String groupId,
    required String travelId,
    required Map<String, TravelerCore> travelers,
  }) async {
    final service = _service(groupId, travelId);
    await service.setAll(travelers);
  }
}
