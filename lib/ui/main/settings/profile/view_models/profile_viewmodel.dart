import 'package:flutter/widgets.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/state/session/app_session.dart';

class ProfileViewModel extends ChangeNotifier {
  final AppSession _appSession;
  final UserSettingsRepository _userSettingsRepository;

  bool _editMode = false;

  bool get editMode => _editMode;

  ProfileViewModel({
    required AppSession appSession,
    required UserSettingsRepository userSettingsRepository,
  }) : _appSession = appSession,
       _userSettingsRepository = userSettingsRepository;

  Future<String> getProfileName() async {
    final uid = _appSession.currentUser!.uid;
    try {
      final name = await _userSettingsRepository.getProfileName(uid);
      return name ?? "";
    } catch (e) {
      return "";
    }
  }
}
