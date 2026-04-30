import 'package:freezed_annotation/freezed_annotation.dart';

part 'shown_travel_basic.freezed.dart';
part 'shown_travel_basic.g.dart';

@freezed
abstract class ShownTravelBasic with _$ShownTravelBasic {
  const factory ShownTravelBasic({String? travelId, String? groupId}) =
      _ShownTravelBasic;

  factory ShownTravelBasic.fromJson(Map<String, dynamic> json) =>
      _$ShownTravelBasicFromJson(json);
}
