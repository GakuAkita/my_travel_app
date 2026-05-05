import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';

import '../../data/model/app_user/app_user.dart';

class AppSession extends ChangeNotifier {
  final AuthRepository _authRepository;
  final UserSettingsRepository _userSettingsRepository;

  late final StreamSubscription _authStateSubscription;

  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  AppSession({required AuthRepository authRepository, required UserSettingsRepository userSettingsRepository})
    : _authRepository = authRepository,
      _userSettingsRepository = userSettingsRepository {
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      if (_currentUser != user) {
        _currentUser = user;
        print("${currentUser?.uid}");
        notifyListeners();
        _userSettingsRepository.setLastLogin(_currentUser!.uid, DateTime.now().toUtc().toIso8601String());
      }
    });
  }

  @override
  void dispose() {
    print("AppSession was disposed");
    print("authStateSubscription canceled");
    _authStateSubscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }
}
