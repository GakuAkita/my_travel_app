import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/repositories/general_manager/general_manager_repository.dart';

class GeneralManagerRepositoryRealtimeDb implements GeneralManagerRepository {
  final FirebaseDatabase _firebaseDatabase;
  final String _userId;

  GeneralManagerRepositoryRealtimeDb({
    required FirebaseDatabase firebaseDatabase,
    required String userId,
  }) : _firebaseDatabase = firebaseDatabase,
       _userId = userId;

  @override
  Future<String?> getGeneralManager(String groupId, String travelId) async {
    // TODO: implement getGeneralManager
    throw AppException("Not implemented getGeneralManager");
  }

  @override
  Future<void> setGeneralManager(
    String groupId,
    String travelId,
    String uid,
  ) async {
    throw AppException("Not implemented setGeneralManager");
  }

  @override
  Future<void> deleteGeneralManager(String groupId, String travelId) async {
    // TODO: implement deleteGeneralManager
    throw AppException("Not implemented deleteGeneralManager");
  }
}
