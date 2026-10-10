import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_auth.dart';

import '../../model/app_user/app_user.dart';

class AuthRepositoryFake implements AuthRepository {
  final FakeAuth _auth;

  AuthRepositoryFake({required FakeAuth auth}) : _auth = auth;

  @override
  Stream<AppUser?> get authStateChanges => _auth.authStateChanges;

  @override
  Future<void> signOut() async => _auth.signOut();
}
