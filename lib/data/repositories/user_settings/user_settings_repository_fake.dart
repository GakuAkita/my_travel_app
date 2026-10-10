import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

import '../../model/travel/shown_travel_basic/shown_travel_basic.dart';

class UserSettingsRepositoryFake implements UserSettingsRepository {
  final FakeDatabase _database;

  UserSettingsRepositoryFake({required FakeDatabase database}) : _database = database;

  @override
  Future<String?> getProfileName(String uid) async =>
      _database.get(FirebaseDatabasePaths.user(uid).settings.profile_name) as String?;

  @override
  Future<void> setProfileName(String uid, String profileName) async =>
      _database.set(FirebaseDatabasePaths.user(uid).settings.profile_name, profileName);

  @override
  Future<String?> getLastLogin(String uid) async =>
      _database.get(FirebaseDatabasePaths.user(uid).settings.last_login_at) as String?;

  @override
  Future<void> setLastLogin(String uid, String lastLogin) async =>
      _database.set(FirebaseDatabasePaths.user(uid).settings.last_login_at, lastLogin);

  @override
  Future<ShownTravelBasic?> getShownTravel(String uid) async {
    final json = _database.get(FirebaseDatabasePaths.user(uid).settings.shown_travel);
    if (json == null) return null;
    return ShownTravelBasic.fromJson(Map<String, dynamic>.from(json));
  }

  @override
  Future<void> setShownTravel(String uid, ShownTravelBasic travel) async =>
      _database.set(FirebaseDatabasePaths.user(uid).settings.shown_travel, travel.toJson());

  @override
  Future<String?> getUserRole(String uid) async => _database.get(FirebaseDatabasePaths.user(uid).role) as String?;

  @override
  Future<void> setUserRole(String uid, String role) async =>
      _database.set(FirebaseDatabasePaths.user(uid).role, role);
}
