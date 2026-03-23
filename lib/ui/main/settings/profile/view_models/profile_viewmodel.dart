import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/state/session/app_session.dart';

class ProfileViewModel extends ChangeNotifier {
  final AppSession _appSession;
  final UserSettingsRepository _userSettingsRepository;

  bool _editMode = false;

  bool get editMode => _editMode;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  late final String _email;

  String get email => _email;

  ProfileViewModel({
    required AppSession appSession,
    required UserSettingsRepository userSettingsRepository,
  }) : _appSession = appSession,
       _userSettingsRepository = userSettingsRepository {
    _email = _appSession.currentUser!.email!;
  }

  Future<String> getProfileName() async {
    final uid = _appSession.currentUser!.uid;
    try {
      final name = await _userSettingsRepository.getProfileName(uid);
      return name ?? "";
    } catch (e) {
      return "";
    }
  }

  Future<ResultInfo> updateProfileName(String name) async {
    if (name == "") {
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: "プロフィール名を入力してください"),
      );
    }
    try {
      final uid = _appSession.currentUser!.uid;
      await _userSettingsRepository.setProfileName(uid, name);
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void switchEditMode() {
    _editMode = !_editMode;
    notifyListeners();
  }
}
