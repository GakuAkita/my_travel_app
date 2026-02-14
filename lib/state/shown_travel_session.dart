import 'package:flutter/foundation.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';

/**
 * General Manager、グループメンバー、
 * 参加者、など旅行に紐づく情報をすべて持っておく
 */
class ShownTravelSession extends ChangeNotifier {
  ShownTravelBasic? _shownTravel;

  void setTravel(ShownTravelBasic? travel) {
    _shownTravel = travel;
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
