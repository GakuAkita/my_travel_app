import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/repositories/auth/auth_credential.dart';

import '../../model/app_user/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;

  Future<ResultInfo<void>> signIn(AppAuthCredential credential);

  Future<ResultInfo<void>> signUp(AppAuthCredential credential);

  Future<ResultInfo<void>> signOut();
}
