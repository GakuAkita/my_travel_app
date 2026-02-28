import 'package:flutter/foundation.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';

/**
 * General Manager、グループメンバー、
 * 参加者、など旅行に紐づく情報をすべて持っておく
 */
class ShownTravelSession extends ChangeNotifier {
  ShownTravelBasic? _shownTravel;

  bool _initialize = false;

  bool get initialized => _initialize;

  ShownTravelSession() {
    print("ShownTravelSession was created");
  }

  void initialize(String uid, UserSettingsRepository repo) {
    print("ShownTravelSession was initialized");
    repo
        .getShownTravel(uid)
        .then((value) {
          /**
       *  仮に失敗してもいい。失敗してもnullが入るだけ。
       *  またユーザーに作り直してもらえば良い。
       *  */
          print(
            "ShownTravelSession was successfully initialized. value=${value?.groupId} ${value?.travelId}",
          );
          _initialize = true;

          //_shownTravel = value;
          _shownTravel = ShownTravelBasic(
            groupId: "groupId",
            travelId: "travelId",
          );
          notifyListeners();
        })
        .catchError((error) {
          print("ShownTravelSession was failed to initialize. $error");
          _initialize = true;
          _shownTravel = null;
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
