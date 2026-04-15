import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_travel_app/data/model/itinerary_table/itinerary_table.dart';

part 'itinerary_section.freezed.dart';
part 'itinerary_section.g.dart';

@freezed
abstract class ItinerarySection with _$ItinerarySection {
  const factory ItinerarySection.markdown({
    required String title,
    required String content,
  }) = MarkdownSection;

  const factory ItinerarySection.table({required ItineraryTable tableData}) =
      TableSection;

  const factory ItinerarySection.space() = SpaceSection;

  factory ItinerarySection.fromJson(Map<String, dynamic> json) =>
      _$ItinerarySectionFromJson(json);
}
