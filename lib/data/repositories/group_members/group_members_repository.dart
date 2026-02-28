import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';

/**
 * 各グループのメンバー
 */
abstract class GroupMembersRepository {
  Future<Map<String, TravelerCore>> getAllGroupMembers(String groupId);

  Future<void> setGroupMembers(String groupId);
}
