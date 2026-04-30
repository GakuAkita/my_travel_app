import 'package:freezed_annotation/freezed_annotation.dart';

import '../traveler_core/traveler_core.dart';

part 'on_itinerary_edit.freezed.dart';
part 'on_itinerary_edit.g.dart';

@freezed
abstract class OnItineraryEdit with _$OnItineraryEdit {
  const OnItineraryEdit._();

  const factory OnItineraryEdit({
    required String uid,
    required String email,
    required bool on_edit,
  }) = _OnItineraryEdit;

  factory OnItineraryEdit.fromJson(Map<String, dynamic> json) =>
      _$OnItineraryEditFromJson(json);

  /// TravelerCoreとして扱いたい時用
  TravelerCore get core => TravelerCore(uid: uid, email: email);

  /// Coreから生成
  factory OnItineraryEdit.fromCore(TravelerCore core, {required bool onEdit}) {
    return OnItineraryEdit(uid: core.uid, email: core.email, on_edit: onEdit);
  }
}
