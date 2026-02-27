import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';

/**
 * 将来的にリポジトリ分割したほうがいいかもな。
 */

abstract class UserSettingsRepository {
  Future<String?> getProfileName();

  Future<void> setProfileName(String profileName);

  Future<ShownTravelBasic?> getShownTravel();

  Future<void> setShownTravel(ShownTravelBasic travel);

  Future<String?> getLastLogin();

  Future<void> setLastLogin(String lastLogin);
}
