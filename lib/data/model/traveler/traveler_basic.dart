import 'package:freezed_annotation/freezed_annotation.dart';

part 'traveler_basic.freezed.dart';
part 'traveler_basic.g.dart';

@freezed
abstract class TravelerBasic with _$TravelerBasic {
  const factory TravelerBasic({
    required String uid,
    required String email,
    @JsonKey(includeToJson: false, includeFromJson: true) String? profile_name,
  }) = _TravelerBasic;

  factory TravelerBasic.fromJson(Map<String, dynamic> json) =>
      _$TravelerBasicFromJson(json);
}
