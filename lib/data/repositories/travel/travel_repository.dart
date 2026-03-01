abstract class TravelRepository {
  Future<String> getTravelName({
    required String groupId,
    required String travelId,
  });

  Future<void> setTravelName({
    required String groupId,
    required String travelId,
    required String travelName,
  });
}
