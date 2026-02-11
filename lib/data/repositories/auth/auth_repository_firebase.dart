import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';

import '../../model/app_user/app_user.dart';
import 'auth_credential.dart';

class AuthRepositoryFirebase implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryFirebase({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      }

      //FirebaseのUserをアプリのAppUserに変換
      return AppUser(uid: firebaseUser.uid, email: firebaseUser.email);
    });
  }

  @override
  Future<ResultInfo<void>> signIn(AppAuthCredential credential) async {
    try {
      if (credential is EmailAppCredential) {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: credential.email,
          password: credential.password,
        );
      } else {
        //他の認証方法
        return ResultInfo.failed(
          error: ErrorInfo(errorMessage: "Unsupported credential type"),
        );
      }
      return ResultInfo.success();
    } on FirebaseAuthException catch (e) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "Firebase Auth Error: ${e.message}"),
      );
    }
  }

  @override
  Future<ResultInfo<void>> signUp(AppAuthCredential credential) async {
    try {
      if (credential is EmailAppCredential) {
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: credential.email,
          password: credential.password,
        );
      } else {
        return ResultInfo.failed(
          error: ErrorInfo(errorMessage: "Unsupported credential type"),
        );
      }

      return ResultInfo.success();
    } on FirebaseAuthException catch (e) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "Firebase Auth Error: ${e.message}"),
      );
    }
  }

  @override
  Future<ResultInfo<void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return ResultInfo.success();
    } on FirebaseAuthException catch (e) {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "Firebase Auth Error:${e.message}"),
      );
    }
  }
}
