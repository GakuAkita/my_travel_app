import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/repositories/general_manager/general_manager_repository.dart';

import '../../../CommonClass/ResultInfo.dart';

class GeneralManagerRepositoryRealtimeDb implements GeneralManagerRepository {
  final FirebaseDatabase _firebaseDatabase;
  final String _userId;

  GeneralManagerRepositoryRealtimeDb({
    required FirebaseDatabase firebaseDatabase,
    required String userId,
  }) : _firebaseDatabase = firebaseDatabase,
       _userId = userId;

  @override
  Future<ResultInfo<String?>> getGeneralManager(
    String groupId,
    String travelId,
  ) async {
    // TODO: implement getGeneralManager
    return ResultInfo.success(data: "aaa");
  }

  @override
  Future<ResultInfo<void>> setGeneralManager(
    String groupId,
    String travelId,
    String uid,
  ) async {
    // TODO: implement setGeneralManager
    return ResultInfo.success();
  }

  @override
  Future<ResultInfo<void>> deleteGeneralManager(
    String groupId,
    String travelId,
  ) async {
    // TODO: implement deleteGeneralManager
    return ResultInfo.success();
  }
}
