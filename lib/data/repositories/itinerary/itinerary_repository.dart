import 'package:my_travel_app/data/model/itinerary_on_edit/itinerary_on_edit.dart';

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

  Future<ItineraryOnEdit?> getItineraryOnEdit({
    required String groupId,
    required String travelId,
  });

  Future<void> setItineraryOnEdit({
    required String groupId,
    required String travelId,
    required ItineraryOnEdit itineraryOnEdit,
  });

  Future<void> removeItineraryOnEdit({
    required String groupId,
    required String travelId,
  });
}
