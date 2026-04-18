import 'package:my_travel_app/data/model/itinerary_table/itinerary_table.dart';
import 'package:my_travel_app/data/repositories/itinerary/itinerary_repository.dart';

import '../../model/itinerary_section/itinerary_section.dart';

class FakeItineraryRepository implements ItineraryRepository {
  @override
  Stream<List<ItinerarySection>> watchItinerarySections({
    required String groupId,
    required String travelId,
  }) {
    return Stream.value(<ItinerarySection>[]);
  }

  @override
  Future<List<ItinerarySection>> getItinerarySections({
    required String groupId,
    required String travelId,
  }) async {
    return [
      ItinerarySection.space(),
      ItinerarySection.table(tableData: ItineraryTable()),
      ItinerarySection.markdown(title: 'サンプル', content: '精神的なこと、これも技術のうち'),
    ];
  }

  @override
  Future<void> saveItinerarySections({
    required String groupId,
    required String travelId,
    required List<ItinerarySection> sections,
  }) async {
    return;
  }
}
