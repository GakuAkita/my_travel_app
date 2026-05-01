import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/repositories/google_auth/google_auth_repository.dart';

class GoogleAuthRepositoryFirebase implements GoogleAuthRepository {
  final FirebaseAuth _firebaseAuth;

  GoogleAuthRepositoryFirebase({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> signIn() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      await _firebaseAuth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      throw AppException(e.toString());
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
