import 'package:my_travel_app/data/repositories/google_auth/google_auth_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_auth.dart';
import 'package:my_travel_app/data/services/fake/fake_cloud_functions.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

/// Googleのアカウント選択はせず、固定のGoogleユーザーでサインインする
class GoogleAuthRepositoryFake implements GoogleAuthRepository {
  static const googleEmail = "google-user@example.com";

  final FakeAuth _auth;
  final FakeDatabase _database;

  GoogleAuthRepositoryFake({required FakeAuth auth, required FakeDatabase database})
    : _auth = auth,
      _database = database;

  @override
  Future<void> signIn() async {
    var account = _auth.findAccount(googleEmail);
    if (account == null) {
      account = _auth.createAccount(email: googleEmail, password: "");
      FakeCloudFunctions.onUserCreate(_database, account.uid, account.email);
    }
    _auth.signIn(account);
  }
}
