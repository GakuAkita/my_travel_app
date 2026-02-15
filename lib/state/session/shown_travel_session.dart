import 'package:flutter/foundation.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/utils/CheckShownTravelBasic.dart';

import '../../data/repositories/shown_travel/shown_travel_repository.dart';

enum TravelSessionStatus {
  /// シーケンスっっぽくなっているので順番は変えない
  idle,
  loadingShownTravel,
  ready,
  error,
}

/**
 * General Manager、グループメンバー、
 * 参加者、など旅行に紐づく情報をすべて持っておく
 */
class ShownTravelSession extends ChangeNotifier {
  final ShownTravelRepository _shownTravelRepository;
  ShownTravelBasic? _shownTravel;

  TravelSessionStatus _status = TravelSessionStatus.idle;

  TravelSessionStatus get status => _status;

  bool _initialized = false;

  bool get initialized => _initialized;

  ShownTravelSession({required ShownTravelRepository shownTravelRepository})
    : _shownTravelRepository = shownTravelRepository {
    print("ShownTravelSession was created");
    /**
     * loadingにしておいて、このsessionを見ている側で
     * loading中だったら終わるまで待てばよいのでは？？
     */
  }

  Future<ResultInfo<void>> initialize() async {
    try {
      /* まずshownTravelを取ってくる */
      /* これが決まればItineraryとExpensesは動き出せる */
      _status = TravelSessionStatus.loadingShownTravel;
      notifyListeners();
      final travelRet = await _shownTravelRepository.getShownTravel();
      if (travelRet.isSuccess) {
        _shownTravel = travelRet.data;
      } else {
        /* 失敗したのでエラーにする */
        _status = TravelSessionStatus.error;
        notifyListeners();
        return travelRet.toVoid();
      }

      if (_shownTravel == null) {
        /* shownTravelが設定されていない場合はメンバーなど必要な情報を取りに行く必要はない */
        _status = TravelSessionStatus.ready;
        notifyListeners();
        return ResultInfo.success();
      }

      if (!checkIsShownTravelValid(_shownTravel!).isSuccess) {
        /* これはおかしい。ここに来るはずはないが、 */
        _status = TravelSessionStatus.error;
        notifyListeners();
        return ResultInfo.failed(
          error: ErrorInfo(errorMessage: "Shown Travel is not valid."),
        );
      }
      notifyListeners(); /* 正常かつ値がtravelに入っている */
      return ResultInfo.success();
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  ShownTravelBasic? get currentTravel => _shownTravel;

  @override
  void dispose() {
    print("ShownTravelSession was disposed");
    // TODO: implement dispose
    super.dispose();
  }
}
