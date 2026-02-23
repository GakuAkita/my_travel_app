import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core.dart';

part 'traveler_basic.freezed.dart';
part 'traveler_basic.g.dart';

/* なんかimplementsが効いていない？？ */
@freezed
abstract class TravelerBasic with _$TravelerBasic {
  const TravelerBasic._();

  const factory TravelerBasic({
    required String uid,
    required String email,
    @JsonKey(includeToJson: false, includeFromJson: true) String? profile_name,
  }) = _TravelerBasic;

  factory TravelerBasic.fromJson(Map<String, dynamic> json) =>
      _$TravelerBasicFromJson(json);
}
