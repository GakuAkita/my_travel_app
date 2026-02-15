import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';

import '../../../CommonClass/ResultInfo.dart';
import '../../../CommonClass/TravelerBasic.dart';

class GroupMembersRepositoryRealtimeDb implements GroupMembersRepository {
  final FirebaseDatabase _firebaseDatabase;
  final String _userId;

  GroupMembersRepositoryRealtimeDb({
    required FirebaseDatabase firebaseDatabase,
    required String userId,
  }) : _firebaseDatabase = firebaseDatabase,
       _userId = userId;

  @override
  Future<ResultInfo<Map<String, TravelerBasic>>> getAllGroupMembers(
    String groupId,
  ) async {
    return ResultInfo.success(data: {});
  }

  @override
  Future<ResultInfo<void>> setGroupMembers(String groupId) async {
    // TODO: implement setGroupMembers
    return ResultInfo.success();
  }
}
