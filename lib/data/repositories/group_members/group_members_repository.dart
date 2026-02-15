import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';

/**
 * 各グループのメンバー
 */
abstract class GroupMembersRepository {
  Future<ResultInfo<Map<String, TravelerBasic>>> getAllGroupMembers(
    String groupId,
  );

  Future<ResultInfo<void>> setGroupMembers(String groupId);
}
