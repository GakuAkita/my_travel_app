import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/repositories/auth/auth_credential.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';

class SignInViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  @override
  void dispose() {
    print("SignInViewModel was disposed");
    // TODO: implement dispose
    super.dispose();
  }

  SignInViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  /* isLoadingの部分を分離してもいいかもな */
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /**
   * メールアドレスでログインする
   */
  Future<ResultInfo<void>> signInWithEmaiil(
    String email,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    final result = await _signInWithEmail(email, password);
    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<ResultInfo<void>> _signInWithEmail(
    String email,
    String password,
  ) async {
    final credential = EmailAppCredential(email: email, password: password);
    final result = await _authRepository.signIn(credential);
    print("${result.error?.errorMessage}");
    return result;
  }

  Future<ResultInfo<void>> signUpWithEmail(
    String email,
    String password,
  ) async {
    final credential = EmailAppCredential(email: email, password: password);
    final result = await _authRepository.signUp(credential);
    print("${result.error?.errorMessage}");
    return result;
  }

  Future<ResultInfo<void>> signUpAndSignInWithEmail(
    String email,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();
    final result = await signUpWithEmail(email, password);
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
}
