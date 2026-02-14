import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';

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
    final result = await _authRepository.signOut();
    return result;
  }
}
