import '../../../CommonClass/ResultInfo.dart';
import 'itinerary_repository.dart';

class ItineraryRepositoryRealtimeDb implements ItineraryRepository {
  @override
  Future<ResultInfo<List<Map<String, dynamic>>>> getItinerarySections(
    String groupId,
    String travelId,
  ) async {
    // TODO: implement getItinerarySections
    throw UnimplementedError();
  }

  @override
  Future<ResultInfo<void>> saveItinerarySections(
    String groupId,
    String travelId,
    List<Map<String, dynamic>> sections,
  ) async {
    // TODO: implement saveItinerarySections
    throw UnimplementedError();
  }
}
