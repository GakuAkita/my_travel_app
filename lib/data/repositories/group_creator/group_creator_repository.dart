import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';

abstract class GroupCreatorRepository {
  Future<TravelerCore?> getGroupCreator(String groupId);

  /// 思ったけど、グループIDは自動生成で絶対被らないようにしないとだめだ。
  /// グループIDが被ったときにかなりまずい。
  Future<void> setGroupCreator(String groupId, TravelerCore travelerCore);
}
