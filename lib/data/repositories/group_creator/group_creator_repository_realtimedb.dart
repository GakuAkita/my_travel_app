import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/group_creator/group_creator_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

import '../../model/traveler/traveler_core/traveler_core.dart';

class GroupCreatorRepositoryRealtimeDb implements GroupCreatorRepository {
  final FirebaseDatabase _database;

  GroupCreatorRepositoryRealtimeDb({required FirebaseDatabase firebaseDatabase})
    : _database = firebaseDatabase;

  FirebaseDatabaseService<TravelerCore> _service(String groupId) {
    return FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.group(groupId).creator,
      fromJson: TravelerCore.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  @override
  Future<TravelerCore?> getGroupCreator(String groupId) async {
    final service = _service(groupId);
    final creator = await service.get();
    return creator;
  }

  @override
  Future<void> setGroupCreator(
    String groupId,
    TravelerCore travelerCore,
  ) async {
    // TODO: implement setGroupCreator
    throw UnimplementedError();
  }
}
