import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';

import '../../../CommonClass/TravelerBasic.dart';
import '../../../core/exceptions/app_exception.dart';

class GroupMembersRepositoryRealtimeDb implements GroupMembersRepository {
  final FirebaseDatabase _firebaseDatabase;
  final String _userId;

  GroupMembersRepositoryRealtimeDb({
    required FirebaseDatabase firebaseDatabase,
    required String userId,
  }) : _firebaseDatabase = firebaseDatabase,
       _userId = userId;

  @override
  Future<Map<String, TravelerBasic>> getAllGroupMembers(String groupId) async {
    // TODO: implement getAllGroupMembers
    throw AppException("Not implemented getAllGroupMembers");
  }

  @override
  Future<void> setGroupMembers(String groupId) async {
    // TODO: implement setGroupMembers
    throw AppException("Not implemented setGroupMembers");
  }
}
