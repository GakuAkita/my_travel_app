import 'package:my_travel_app/CommonClass/TravelerBasic.dart';

/**
 * 各グループのメンバー
 */
abstract class GroupMembersRepository {
  Future<Map<String, TravelerBasic>> getAllGroupMembers(String groupId);

  Future<void> setGroupMembers(String groupId);
}
