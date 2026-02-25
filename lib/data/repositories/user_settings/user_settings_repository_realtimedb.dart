import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';

import '../../model/travel/shown_travel_basic/shown_travel_basic.dart';

class UserSettingsRepositoryRealtimeDb implements UserSettingsRepository {
  @override
  Future<String> getProfileName() {
    // TODO: implement getProfileName
    throw UnimplementedError();
  }

  @override
  Future<void> setProfileName() {
    // TODO: implement setProfileName
    throw UnimplementedError();
  }

  @override
  Future<void> getLastLogin() {
    // TODO: implement getLastLogin
    throw UnimplementedError();
  }

  @override
  Future<void> setLastLogin() {
    // TODO: implement setLastLogin
    throw UnimplementedError();
  }

  @override
  Future<ShownTravelBasic> getShownTravel() {
    // TODO: implement getShownTravel
    throw UnimplementedError();
  }

  @override
  Future<void> setShownTravel(ShownTravelBasic travel) {
    // TODO: implement setShownTravel
    throw UnimplementedError();
  }
}
