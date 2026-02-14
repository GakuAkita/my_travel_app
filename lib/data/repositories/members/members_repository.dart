import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';

/**
 * 各グループのメンバー
 */
abstract class MembersRepository {
  Future<ResultInfo<Map<String, TravelerBasic>>> getAllMembers(String groupId);

  Future<ResultInfo<void>> setMembers(String groupId);
}
