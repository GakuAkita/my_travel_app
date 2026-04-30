

abstract class GeneralManagerRepository {
  Future<String?> getGeneralManager(String groupId, String travelId);

  Future<void> setGeneralManager(String groupId, String travelId, String uid);

  Future<void> deleteGeneralManager(String groupId, String travelId);
}
