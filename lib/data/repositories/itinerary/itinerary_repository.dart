import 'package:my_travel_app/CommonClass/ItinerarySection.dart';

abstract class ItineraryRepository {
  Stream<List<ItinerarySection>> watchItinerarySections(
    String groupId,
    String travelId,
  );

  Future<List<ItinerarySection>> getItinerarySections(
    String groupId,
    String travelId,
  );

  Future<void> saveItinerarySections(
    String groupId,
    String travelId,
    List<ItinerarySection> sections,
  );
}
