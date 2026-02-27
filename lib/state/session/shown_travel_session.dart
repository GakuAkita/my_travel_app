import 'package:flutter/foundation.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/shown_travel/shown_travel_repository.dart';

/**
 * General Manager、グループメンバー、
 * 参加者、など旅行に紐づく情報をすべて持っておく
 */
class ShownTravelSession extends ChangeNotifier {
  ShownTravelBasic? _shownTravel;

  ShownTravelSession() {
    print("ShownTravelSession was created");
  }

  void initialize(ShownTravelRepository repo) {
    print("ShownTravelSession was initialized");
    repo.getShownTravel().then((value) {
      _shownTravel = value;
      notifyListeners();
    });
  }

  /**
   * ここは直接叩かないこと。
   * UseCaseを経由して使用する。
   */
  void setShownTravel(ShownTravelBasic? newTravel) async {
    _shownTravel = newTravel;
    notifyListeners();
  }

  ShownTravelBasic? get currentTravel => _shownTravel;

  @override
  void dispose() {
    print("ShownTravelSession was disposed");
    // TODO: implement dispose
    super.dispose();
  }
}
