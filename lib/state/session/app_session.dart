import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';

import '../../data/model/app_user/app_user.dart';

class AppSession extends ChangeNotifier {
  final AuthRepository _authRepository;
  late final StreamSubscription _authStateSubscription;

  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  AppSession({required AuthRepository authRepository})
    : _authRepository = authRepository {
    _authStateSubscription = authRepository.authStateChanges.listen((user) {
      if (_currentUser != user) {
        _currentUser = user;
        print("${currentUser?.uid}");
        notifyListeners();
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
