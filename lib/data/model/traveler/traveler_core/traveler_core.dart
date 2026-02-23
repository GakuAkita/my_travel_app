/* なんかimplementsが効いていない？？ */
import 'package:freezed_annotation/freezed_annotation.dart';

part 'traveler_core.freezed.dart';
part 'traveler_core.g.dart';

@freezed
abstract class TravelerCore with _$TravelerCore {
  const factory TravelerCore({required String uid, required String email}) =
      _TravelerCore;

  factory TravelerCore.fromJson(Map<String, dynamic> json) =>
      _$TravelerCoreFromJson(json);
}
