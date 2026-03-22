/**
 * あるグループの所持しているtravelIdを全部取ってくる。
 */
abstract class TravelKeysRepository {
  Future<List<String>> getGroupTravelIds(String groupId);

  Future<void> addGroupTravelId(String groupId, String travelId);

  Future<void> removeGroupTravelId(String groupId, String travelId);

  Future<void> removeAllGroupTravelIds(String groupId);
}
