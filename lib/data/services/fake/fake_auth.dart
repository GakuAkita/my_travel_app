import 'dart:async';

import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/model/app_user/app_user.dart';
import 'package:my_travel_app/ui/start/reset_pass/auth_error_codes.dart';

class FakeAccount {
  final String uid;
  final String email;
  final String password;

  const FakeAccount({required this.uid, required this.email, required this.password});
}

/// Firebase Authをメモリ上で再現したもの(Fakeモード用)
class FakeAuth {
  final Map<String, FakeAccount> _accounts = {}; /* key: email */
  final StreamController<AppUser?> _controller = StreamController<AppUser?>.broadcast();
  AppUser? _currentUser;
  int _uidCounter = 0;

  AppUser? get currentUser => _currentUser;

  /// 本物と同じく、listenした時点の状態を最初に流す
  Stream<AppUser?> get authStateChanges {
    StreamSubscription<AppUser?>? subscription;
    late final StreamController<AppUser?> controller;
    controller = StreamController<AppUser?>(
      onListen: () {
        controller.add(_currentUser);
        subscription = _controller.stream.listen(controller.add);
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }

  FakeAccount? findAccount(String email) => _accounts[email];

  FakeAccount createAccount({required String email, required String password, String? uid}) {
    if (_accounts.containsKey(email)) {
      throw AppException("Fake Auth Error: The email address is already in use.", code: 'email-already-in-use');
    }
    final account = FakeAccount(uid: uid ?? "fake-uid-${_uidCounter++}", email: email, password: password);
    _accounts[email] = account;
    return account;
  }

  FakeAccount signInWithEmail(String email, String password) {
    final account = _accounts[email];
    if (account == null) {
      throw AppException("Fake Auth Error: There is no user with this email.", code: AuthErrorCodes.userNotFound);
    }
    if (account.password != password) {
      throw AppException("Fake Auth Error: The password is invalid.", code: 'wrong-password');
    }
    signIn(account);
    return account;
  }

  void signIn(FakeAccount account) {
    _currentUser = AppUser(uid: account.uid, email: account.email);
    _controller.add(_currentUser);
  }

  void signOut() {
    _currentUser = null;
    _controller.add(null);
  }
}
