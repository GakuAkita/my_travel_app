import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/repositories/email_auth/email_auth_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_auth.dart';
import 'package:my_travel_app/data/services/fake/fake_cloud_functions.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

import '../../../ui/start/reset_pass/auth_error_codes.dart';

class EmailAuthRepositoryFake implements EmailAuthRepository {
  final FakeAuth _auth;
  final FakeDatabase _database;

  EmailAuthRepositoryFake({required FakeAuth auth, required FakeDatabase database})
    : _auth = auth,
      _database = database;

  @override
  Future<void> signIn({required String email, required String password}) async {
    _auth.signInWithEmail(email, password);
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    /* 本物と同じく、作成したらそのままサインインした状態になる */
    final account = _auth.createAccount(email: email, password: password);
    FakeCloudFunctions.onUserCreate(_database, account.uid, account.email);
    _auth.signIn(account);
  }

  @override
  Future<void> sendResetPassword(String email) async {
    if (_auth.findAccount(email) == null) {
      throw AppException("指定されたメールアドレスのユーザーが存在しません", code: AuthErrorCodes.userNotFound);
    }
    print("[Fake] Password reset mail was sent to $email");
  }
}
