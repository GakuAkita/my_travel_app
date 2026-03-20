import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';

abstract class GroupCreatorRepository {
  Future<TravelerCore?> getGroupCreator(String groupId);

  Future<void> setGroupCreator(String groupId, TravelerCore travelerCore);
}
