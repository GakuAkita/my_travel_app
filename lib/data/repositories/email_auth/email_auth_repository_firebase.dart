import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_travel_app/data/repositories/email_auth/email_auth_repository.dart';

import '../../../core/exceptions/app_exception.dart';
import '../../../ui/start/reset_pass/auth_error_codes.dart';

class EmailAuthRepositoryFirebase implements EmailAuthRepository {
  final FirebaseAuth _firebaseAuth;

  EmailAuthRepositoryFirebase({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AppException("Firebase Auth Error: ${e.message}");
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AppException("Firebase Auth Error: ${e.message}");
    } catch (e) {
      throw AppException(e.toString());
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
}
