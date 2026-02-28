import 'traveler_core/traveler_core.dart';

class TravelerBasic {
  final TravelerCore core;
  final String? profile_name;

  TravelerBasic({required this.core, this.profile_name});

  TravelerBasic copyWith({TravelerCore? core, String? profile_name}) {
    return TravelerBasic(
      core: core ?? this.core,
      profile_name: profile_name ?? this.profile_name,
    );
  }
}

extension TravelerMapExtension on Map<String, TravelerCore> {
  /// Map<String, TravelerCore> → Map<String, TravelerBasic> に変換
  /// profile_name は null
  Map<String, TravelerBasic> toTravelerBasicMap() {
    return Map.fromEntries(
      entries.map((e) => MapEntry(e.key, TravelerBasic(core: e.value))),
    );
  }
}
