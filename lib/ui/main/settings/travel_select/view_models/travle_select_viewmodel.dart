import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/domain/use_cases/get_user_travels_use_case.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';

import '../../../../../data/model/travel/shown_travel_basic/shown_travel_basic.dart';

class TravelSelectViewModel extends ChangeNotifier {
  final GetUserTravelsUseCase _getUserTravelsUseCase;
  final AppSession _appSession;
  final ShownTravelSession _travelSession;

  TravelSelectViewModel({
    required AppSession appSession,
    required ShownTravelSession travelSession,
    required GetUserTravelsUseCase getUserTravelsUseCase,
  }) : _getUserTravelsUseCase = getUserTravelsUseCase,
       _appSession = appSession,
       _travelSession = travelSession {
    initialize();
  }

  Map<String, Map<String, String>>? _userTravels;

  Map<String, Map<String, String>>? get userTravels => _userTravels;

  String? _selectedTravelId;

  String? get selectedTravelId => _selectedTravelId;

  Future<void> initialize() async {
    _selectedTravelId = _travelSession.currentTravel?.travelId;

    final uid = _appSession.currentUser!.uid;
    _userTravels = await _getUserTravelsUseCase.getUserTravelsWithNames(uid);
    notifyListeners();
  }

  void setSelectTravelId(String travelId) {
    _selectedTravelId = travelId;
    notifyListeners();
  }

  ResultInfo switchToSelectedTravel() {
    /* 選択されているtravelIdをもつgroupIdを取ってきて、ShownTravelを作る */
    final travelId = _selectedTravelId;
    if (travelId == null) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "旅行が選択され愛知ません"));
    }

    if (_userTravels == null) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "旅行が取得できていません。"));
    }

    String? groupId;
    for (final entry in _userTravels!.entries) {
      if (entry.value.containsKey(travelId)) {
        groupId = entry.key;
        break;
      }
    }
    if (groupId == null) {
      return ResultInfo.failed(
        error: ErrorInfo(
          errorMessage: "旅行IDからグループIDを取得できませんでした。おそらくコーディングエラーです。",
        ),
      );
    }

    final newTravel = ShownTravelBasic(groupId: groupId, travelId: travelId);
    _travelSession.setShownTravel(newTravel);

    /* ShownTravelを設定する */
    return ResultInfo.success();
  }
}
