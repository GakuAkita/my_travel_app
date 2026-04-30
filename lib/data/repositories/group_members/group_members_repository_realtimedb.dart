import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

class GroupMembersRepositoryRealtimeDb implements GroupMembersRepository {
  final FirebaseDatabase _firebaseDatabase;

  GroupMembersRepositoryRealtimeDb({required FirebaseDatabase firebaseDatabase})
    : _firebaseDatabase = firebaseDatabase;

  FirebaseDatabaseService<TravelerCore> _service(String groupId) {
    return FirebaseDatabaseService(
      database: _firebaseDatabase,
      path: FirebaseDatabasePaths.group(groupId).members,
      fromJson: TravelerCore.fromJson,
      toJson: (value) => value.toJson(),
    );
  }

  @override
  Future<Map<String, TravelerCore>> getAllGroupMembers(String groupId) async {
    final service = _service(groupId);
    final members = await service.getAll();
    return members;
  }

  @override
  Future<void> setGroupMembers(
    String groupId,
    Map<String, TravelerCore> members,
  ) async {
    final service = _service(groupId);
    await service.setAll(members);
  }
}
