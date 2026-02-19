

abstract class ItineraryRepository {
  //Future<ResultInfo<>>
  Future<List<Map<String, dynamic>>> getItinerarySections(
    String groupId,
    String travelId,
  );

  Future<void> saveItinerarySections(
    String groupId,
    String travelId,
    List<Map<String, dynamic>> sections,
  );
}
