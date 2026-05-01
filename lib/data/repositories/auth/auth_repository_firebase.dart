import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';
import 'package:my_travel_app/ui/start/reset_pass/auth_error_codes.dart';

import '../../model/app_user/app_user.dart';
import 'auth_credential.dart';

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
  Future<void> signIn(AppAuthCredential credential) async {
    try {
      if (credential is EmailAppCredential) {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: credential.email,
          password: credential.password,
        );
      } else if (credential is GoogleAppCredential) {
        // https://firebase.google.com/docs/auth/flutter/federated-auth?hl=ja
        /* Google認証 */
        final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();
        if (googleUser == null) {
          throw AppException("Googleアカウントの認証に失敗しました");
        }

        final GoogleSignInAuthentication googleAuth = googleUser.authentication;

        final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

        await _firebaseAuth.signInWithCredential(credential);

        /* サインインして、 */
      } else {
        //他の認証方法
        /* ここには来ない。ちゃんと実装してくれ。 */
        throw AppException("Unsupported credential type");
      }
    } on FirebaseAuthException catch (e) {
      throw AppException("Firebase Auth Error: ${e.message}");
    }
  }

  @override
  Future<void> signUp(AppAuthCredential credential) async {
    try {
      if (credential is EmailAppCredential) {
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: credential.email,
          password: credential.password,
        );
      } else {
        throw AppException("Unsupported credential type");
      }
    } on FirebaseAuthException catch (e) {
      throw AppException("Firebase Auth Error: ${e.message}");
    }
  }

  @override
  Future<void> sendResetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case AuthErrorCodes.invalidEmail:
          throw AppException("メールアドレスの形式が正しくありません", code: e.code);

        case AuthErrorCodes.userNotFound:
          throw AppException("指定されたメールアドレスのユーザーが存在しません", code: e.code);

        case AuthErrorCodes.tooManyRequests:
          throw AppException("リクエストが多すぎます。しばらく待ってからお試しください", code: e.code);

        default:
          throw AppException("Firebase:不明なエラーが発生しました", code: e.code);
      }
    } catch (e) {
      throw AppException("不明なエラーが発生しました", code: AuthErrorCodes.unknown);
    }
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
