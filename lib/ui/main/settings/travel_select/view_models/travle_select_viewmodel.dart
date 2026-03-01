import 'package:flutter/widgets.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';

class TravelSelectViewModel extends ChangeNotifier {
  final UserSettingsRepository _userSettingsRepository;

  TravelSelectViewModel({
    required UserSettingsRepository userSettingsRepository,
  }) : _userSettingsRepository = userSettingsRepository;
}
