import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';

import '../../model/app_user/app_user.dart';

class AuthRepositoryFirebase implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  List<String> scopes = <String>['https://www.googleapis.com/auth/contacts.readonly'];

  AuthRepositoryFirebase({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      }

      print("Detected AppUser change.");
      //FirebaseのUserをアプリのAppUserに変換
      return AppUser(uid: firebaseUser.uid, email: firebaseUser.email);
    });
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AppException("Firebase Auth Error: ${e.message}");
    }
  }
}
