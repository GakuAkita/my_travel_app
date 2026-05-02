import '../../model/app_user/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;

  Future<void> signOut();
}
