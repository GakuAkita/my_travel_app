import 'traveler_core/traveler_core.dart';

class TravelerBasic {
  final TravelerCore core;
  final String? profile_name;

  TravelerBasic({required this.core, this.profile_name});

  //表示用
  String get displayName {
    return profile_name ?? core.email;
  }

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

extension TravelerBasicMapExt on Map<String, TravelerBasic> {
  String getProfileName(String uid) {
    return this[uid]?.displayName ?? "Unknown";
  }
}
