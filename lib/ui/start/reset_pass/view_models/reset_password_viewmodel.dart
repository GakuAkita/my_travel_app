import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/repositories/email_auth/email_auth_repository.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final EmailAuthRepository _emailAuthRepository;

  String _email = "";

  ResetPasswordViewModel({required EmailAuthRepository emailAuthRepository})
    : _emailAuthRepository = emailAuthRepository;

  void updateEmail(String email) {
    _email = email;
    /* 外に使えるわけではないので、notifyListeners()は使わない */
  }

  Future<ResultInfo> sendResetPassword() async {
    try {
      print(_email);
      await _emailAuthRepository.sendResetPassword(_email);
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }
}
