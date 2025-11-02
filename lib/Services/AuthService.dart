import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';

class AuthResult {
  final UserCredential? userCredential;
  final String? errorCode;
  final String? message;

  AuthResult({this.userCredential, this.errorCode, this.message});
}

class SignOutResult {
  final bool success;
  final String? message;

  SignOutResult({required this.success, this.message});
}

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  Future<AuthResult> login(String email, String password) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(userCredential: user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(errorCode: e.code, message: e.message);
    } catch (e) {
      return AuthResult(errorCode: 'unknown-error', message: e.toString());
    }
  }

  Future<AuthResult> signUp(String email, String password) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(userCredential: user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(errorCode: e.code, message: e.message);
    } catch (e) {
      return AuthResult(errorCode: 'unknown-error', message: e.toString());
    }
  }

  Future<SignOutResult> signOut() async {
    try {
      await _auth.signOut();
      return SignOutResult(success: true);
    } catch (e) {
      return SignOutResult(success: false, message: e.toString());
    }
  }

  Future<ResultInfo> sendResetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return ResultInfo.success();
    } on FirebaseAuthException catch (e) {
      var message = "";
      switch (e.code) {
        case FirebaseAuthErrorCodes.invalidEmail:
          message = "メールアドレスの形式が正しくありません";
          break;
        case FirebaseAuthErrorCodes.userNotFound:
          message = "指定されたメールアドレスのユーザーが存在しません";
          break;
        case FirebaseAuthErrorCodes.tooManyRequests:
          message = "リクエストが多すぎます。しばらくして再度お試しください";
          break;
        default:
          message = "不明なエラーが発生しました:${e.message}";
      }
      return ResultInfo.failed(
        error: ErrorInfo(errorCode: e.code, errorMessage: message),
      );
    } catch (e) {
      return ResultInfo.failed(
        error: ErrorInfo(
          errorCode: "UNKNOWN_ERROR",
          errorMessage: "予期せぬエラーが発生しました",
        ),
      );
    }
  }
}

class FirebaseAuthErrorCodes {
  static const invalidEmail = 'invalid-email';
  static const userNotFound = 'user-not-found';
  static const tooManyRequests = 'too-many-requests';
  // 必要に応じて追加
}
