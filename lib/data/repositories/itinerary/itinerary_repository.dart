import '../../model/itinerary_section/itinerary_section.dart';

abstract class ItineraryRepository {
  Stream<List<ItinerarySection>> watchItinerarySections({
    required String groupId,
    required String travelId,
  });

  Future<List<ItinerarySection>> getItinerarySections({
    required String groupId,
    required String travelId,
  });

  Future<void> saveItinerarySections({
    required String groupId,
    required String travelId,
    required List<ItinerarySection> sections,
  });
}
