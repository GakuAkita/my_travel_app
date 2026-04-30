import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

import '../../model/travel/shown_travel_basic/shown_travel_basic.dart';

class UserSettingsRepositoryRealtimeDb implements UserSettingsRepository {
  final FirebaseDatabase _database;

  UserSettingsRepositoryRealtimeDb({required FirebaseDatabase database})
    : _database = database;

  FirebaseDatabaseService _serviceSingleValue(String path) {
    return FirebaseDatabaseService(
      database: _database,
      path: path,
      fromJson: (json) => json,
      toJson: (value) => value,
    );
  }

  @override
  Future<String?> getProfileName(String uid) async {
    final service = _serviceSingleValue(
      FirebaseDatabasePaths.user(uid).settings.profile_name,
    );
    final profileName = await service.getValue<String?>();
    return profileName;
  }

  @override
  Future<void> setProfileName(String uid, String profileName) async {
    final service = _serviceSingleValue(
      FirebaseDatabasePaths.user(uid).settings.profile_name,
    );
    await service.setValue(profileName);
  }

  @override
  Future<String?> getLastLogin(String uid) async {
    final service = _serviceSingleValue(
      FirebaseDatabasePaths.user(uid).settings.last_login_at,
    );
    final lastLogin = await service.getValue<String?>();
    return lastLogin;
  }

  @override
  Future<void> setLastLogin(String uid, String lastLogin) async {
    final service = _serviceSingleValue(
      FirebaseDatabasePaths.user(uid).settings.last_login_at,
    );
    await service.setValue(lastLogin);
  }

  @override
  Future<ShownTravelBasic?> getShownTravel(String uid) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.user(uid).settings.shown_travel,
      fromJson: ShownTravelBasic.fromJson,
      toJson: (travel) => travel.toJson(),
    );
    print("${service.path}");
    final travel = await service.get();
    return travel;
  }

  @override
  Future<void> setShownTravel(String uid, ShownTravelBasic travel) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.user(uid).settings.shown_travel,
      fromJson: ShownTravelBasic.fromJson,
      toJson: (travel) => travel.toJson(),
    );
    await service.set(travel);
  }

  @override
  Future<String?> getUserRole(String uid) async {
    final service = _serviceSingleValue(FirebaseDatabasePaths.user(uid).role);
    final role = await service.getValue<String?>();
    return role;
  }

  @override
  Future<void> setUserRole(String uid, String role) async {
    final service = _serviceSingleValue(FirebaseDatabasePaths.user(uid).role);
    await service.setValue(role);
  }
}
