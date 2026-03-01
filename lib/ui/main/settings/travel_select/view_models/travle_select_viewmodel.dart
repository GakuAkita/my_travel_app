import 'package:flutter/widgets.dart';
import 'package:my_travel_app/domain/use_cases/get_user_travels_use_case.dart';
import 'package:my_travel_app/state/session/app_session.dart';

class TravelSelectViewModel extends ChangeNotifier {
  final GetUserTravelsUseCase _getUserTravelsUseCase;
  final AppSession _appSession;

  TravelSelectViewModel({
    required AppSession appSession,
    required GetUserTravelsUseCase getUserTravelsUseCase,
  }) : _getUserTravelsUseCase = getUserTravelsUseCase,
       _appSession = appSession {
    initialize();
  }

  Map<String, Map<String, String>>? _userTravels;

  Map<String, Map<String, String>>? get userTravels => _userTravels;

  String? _selectedTravelId;

  String? get selectedTravelId => _selectedTravelId;

  Future<void> initialize() async {
    final uid = _appSession.currentUser!.uid;
    _userTravels = await _getUserTravelsUseCase.getUserTravelsWithNames(uid);
    notifyListeners();
  }

  void setSelectTravelId(String travelId) {
    _selectedTravelId = travelId;
    notifyListeners();
  }
}
