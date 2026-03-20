import 'package:my_travel_app/data/repositories/group_creator/group_creator_repository.dart';

import '../../model/traveler/traveler_core/traveler_core.dart';

class GroupCreatorRepositoryRealtimeDb implements GroupCreatorRepository {
  @override
  Future<TravelerCore> getGroupCreator(String groupId) async {
    // TODO: implement getGroupCreator
    throw UnimplementedError();
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
