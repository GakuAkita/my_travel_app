import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';

/**
 * 将来的にリポジトリ分割したほうがいいかもな。
 */

abstract class UserSettingsRepository {
  Future<String?> getProfileName(String uid);

  Future<void> setProfileName(String uid, String profileName);

  Future<ShownTravelBasic?> getShownTravel(String uid);

  Future<void> setShownTravel(String uid, ShownTravelBasic travel);

  Future<String?> getLastLogin(String uid);

  Future<void> setLastLogin(String uid, String lastLogin);
}
