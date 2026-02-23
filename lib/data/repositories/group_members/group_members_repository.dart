import '../../model/traveler/traveler_basic/traveler_basic.dart';

/**
 * 各グループのメンバー
 */
abstract class GroupMembersRepository {
  Future<Map<String, TravelerBasic>> getAllGroupMembers(String groupId);

  Future<void> setGroupMembers(String groupId);
}
