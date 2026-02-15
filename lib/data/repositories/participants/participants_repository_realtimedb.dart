import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/repositories/participants/participants_repository.dart';

import '../../../CommonClass/ResultInfo.dart';
import '../../../CommonClass/TravelerBasic.dart';

class ParticipantsRepositoryRealtimeDb implements ParticipantsRepository {
  final FirebaseDatabase _firebaseDatabase;
  final String _userId;

  ParticipantsRepositoryRealtimeDb({
    required FirebaseDatabase firebaseDatabase,
    required String userId,
  }) : _firebaseDatabase = firebaseDatabase,
       _userId = userId;

  @override
  Future<ResultInfo<Map<String, TravelerBasic>>> getAllTravelers(
    String groupId,
    String travelId,
  ) async {
    // TODO: implement getAllTravelers
    return ResultInfo.success(data: {});
  }

  @override
  Future<ResultInfo<void>> saveAllTravelers(
    String groupId,
    String travelId,
    Map<String, TravelerBasic> travelers,
  ) async {
    // TODO: implement saveAllTravelers
    return ResultInfo.success();
  }
}
