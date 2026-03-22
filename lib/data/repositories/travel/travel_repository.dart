abstract class TravelRepository {
  Future<String> getTravelName({
    required String groupId,
    required String travelId,
  });

  /* 新しくpushして追加する */
  Future<String> addTravelId({
    required String groupId,
    required String travelName,
  });

  Future<void> deleteTravel({
    required String groupId,
    required String travelId,
  });
}
