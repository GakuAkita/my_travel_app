import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';

import '../../../../../CommonClass/ErrorInfo.dart';

class SettingsViewModel extends ChangeNotifier {
  AuthRepository _authRepository;

  SettingsViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  void dispose() {
    print("SettingsViewModel was disposed");
    // TODO: implement dispose
    super.dispose();
  }

  Future<ResultInfo<void>> signOut() async {
    try {
      await _authRepository.signOut();
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }
}
