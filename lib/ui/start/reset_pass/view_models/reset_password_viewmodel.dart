import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';

import '../../../../data/repositories/auth/auth_repository.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  String _email = "";

  ResetPasswordViewModel({required AuthRepository authRepository}) : _authRepository = authRepository;

  void updateEmail(String email) {
    _email = email;
    /* 外に使えるわけではないので、notifyListeners()は使わない */
  }

  Future<ResultInfo> sendResetPassword() async {
    try {
      print(_email);
      await _authRepository.sendResetPassword(_email);
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }
}
