import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/repositories/auth/auth_repository.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/ui/core/store/data_state.dart';

import '../../../../../CommonClass/ErrorInfo.dart';

class SettingsViewModel extends ChangeNotifier {
  AppSession _appSession;
  AuthRepository _authRepository;
  UserSettingsRepository _userSettingsRepository;

  /* エラーのときだけ再取得ボタンを表示させる */
  DataState<String?> _roleState = DataState();

  DataState<String?> get roleState => _roleState;

  SettingsViewModel({
    required AppSession appSession,
    required AuthRepository authRepository,
    required UserSettingsRepository userSettingsRepository,
  }) : _appSession = appSession,
       _authRepository = authRepository,
       _userSettingsRepository = userSettingsRepository {
    print("SettingsViewModel was created. hashCode=${hashCode}");
    fetchUserRoles();
  }

  Future<void> fetchUserRoles() async {
    try {
      final uid = _appSession.currentUser!.uid;
      final role = await _userSettingsRepository.getUserRole(uid);
      _roleState = DataState(data: role);
      notifyListeners();
    } catch (e) {
      _roleState = DataState(error: ErrorInfo(errorMessage: e.toString()));
      notifyListeners();
    }
  }

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
