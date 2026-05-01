import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/repositories/email_auth/email_auth_repository.dart';

import '../../../../CommonClass/ErrorInfo.dart';

class SignInViewModel extends ChangeNotifier {
  final EmailAuthRepository _emailAuthRepository;

  @override
  void dispose() {
    print("SignInViewModel was disposed");
    // TODO: implement dispose
    super.dispose();
  }

  SignInViewModel({required EmailAuthRepository emailAuthRepository})
    : _emailAuthRepository = emailAuthRepository;

  /* isLoadingの部分を分離してもいいかもな */
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /**
   * メールアドレスでログインする
   */
  Future<ResultInfo<void>> signInWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _signInWithEmail(email, password);
    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<ResultInfo<void>> _signInWithEmail(String email, String password) async {
    try {
      await _emailAuthRepository.signIn(email: email, password: password);
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  Future<ResultInfo<void>> _signUpWithEmail(String email, String password) async {
    try {
      await _emailAuthRepository.signUp(email: email, password: password);
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  Future<ResultInfo<void>> signUpAndSignInWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final result = await _signUpWithEmail(email, password);
    if (!result.isSuccess) {
      _isLoading = false;
      notifyListeners();
      return result;
    }

    final signInResult = await _signInWithEmail(email, password);
    _isLoading = false;
    notifyListeners();
    return signInResult;
  }

  Future<ResultInfo> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
