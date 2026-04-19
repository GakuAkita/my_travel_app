import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';

part 'itinerary_on_edit.freezed.dart';
part 'itinerary_on_edit.g.dart';

@freezed
abstract class ItineraryOnEdit with _$ItineraryOnEdit {
  const factory ItineraryOnEdit({
    required bool? onEdit,
    required TravelerCore? editor,
  }) = _ItineraryOnEdit;

  factory ItineraryOnEdit.fromJson(Map<String, dynamic> json) =>
      _$ItineraryOnEditFromJson(json);
}
