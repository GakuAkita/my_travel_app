import 'package:my_travel_app/data/repositories/auth/auth_credential.dart';

import '../../model/app_user/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;

  Future<void> signIn(AppAuthCredential credential);

  Future<void> signUp(AppAuthCredential credential);

  Future<void> signOut();
}
