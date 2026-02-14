import '../../../CommonClass/ResultInfo.dart';

abstract class ItineraryRepository {
  //Future<ResultInfo<>>
  Future<ResultInfo<List<Map<String, dynamic>>>> getItinerarySections(
    String groupId,
    String travelId,
  );

  Future<ResultInfo<void>> saveItinerarySections(
    String groupId,
    String travelId,
    List<Map<String, dynamic>> sections,
  );
}
