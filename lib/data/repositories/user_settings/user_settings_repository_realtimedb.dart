import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

import '../../model/travel/shown_travel_basic/shown_travel_basic.dart';

class UserSettingsRepositoryRealtimeDb implements UserSettingsRepository {
  final FirebaseDatabase _database;
  final String _userId;

  UserSettingsRepositoryRealtimeDb({
    required FirebaseDatabase database,
    required String userId,
  }) : _database = database,
       _userId = userId;

  FirebaseDatabaseService _serviceSingleValue(String path) {
    return FirebaseDatabaseService(
      database: _database,
      path: path,
      fromJson: (json) => json,
      toJson: (value) => value,
    );
  }

  @override
  Future<String?> getProfileName() async {
    final service = _serviceSingleValue(
      FirebaseDatabasePaths.user(_userId).settings.profile_name,
    );
    final profileName = await service.getValue<String?>();
    return profileName;
  }

  @override
  Future<void> setProfileName(String profileName) async {
    final service = _serviceSingleValue(
      FirebaseDatabasePaths.user(_userId).settings.profile_name,
    );
    await service.setValue(profileName);
  }

  @override
  Future<String?> getLastLogin() async {
    final service = _serviceSingleValue(
      FirebaseDatabasePaths.user(_userId).settings.last_login_at,
    );
    final lastLogin = await service.getValue<String?>();
    return lastLogin;
  }

  @override
  Future<void> setLastLogin(String lastLogin) async {
    final service = _serviceSingleValue(
      FirebaseDatabasePaths.user(_userId).settings.last_login_at,
    );
    await service.setValue(lastLogin);
  }

  @override
  Future<ShownTravelBasic?> getShownTravel() async {
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.user(_userId).settings.shown_travel,
      fromJson: ShownTravelBasic.fromJson,
      toJson: (travel) => travel.toJson(),
    );
    final travel = await service.get();
    return travel;
  }

  @override
  Future<void> setShownTravel(ShownTravelBasic travel) async {
    final service = FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.user(_userId).settings.shown_travel,
      fromJson: ShownTravelBasic.fromJson,
      toJson: (travel) => travel.toJson(),
    );
    await service.set(travel);
  }
}
