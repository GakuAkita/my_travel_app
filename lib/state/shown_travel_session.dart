import 'package:flutter/foundation.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/general_manager/general_manager_repository.dart';
import 'package:my_travel_app/data/repositories/members/members_repository.dart';
import 'package:my_travel_app/data/repositories/participants/travelers_repository.dart';
import 'package:my_travel_app/utils/CheckShownTravelBasic.dart';

import '../data/repositories/shown_travel/shown_travel_repository.dart';

enum TravelSessionStatus {
  /// シーケンスっっぽくなっているので順番は変えない
  idle,
  loadingShownTravel,
  loadingMembers,
  loadingParticipants,
  loadingGManager,
  loadingPlanner,
  ready,
  error,
}

/**
 * General Manager、グループメンバー、
 * 参加者、など旅行に紐づく情報をすべて持っておく
 */
class ShownTravelSession extends ChangeNotifier {
  final ShownTravelRepository _shownTravelRepository;
  final MembersRepository _membersRepository;
  final ParticipantsRepository _participantsRepository;
  final GeneralManagerRepository _gManagerRepository;

  ShownTravelBasic? _shownTravel;

  TravelSessionStatus _status = TravelSessionStatus.idle;

  Map<String, TravelerBasic> _groupMembers = {};

  /* null許容しなくていいか。 */
  Map<String, TravelerBasic> get groupMembers => _groupMembers;

  String? _generalManager;

  String? get generalManager => _generalManager;

  Map<String, TravelerBasic> _planner = {};

  /* 複数いたほうが良いかも */
  Map<String, TravelerBasic> get planner => _planner;

  bool _initialized = false;

  bool get initialized => _initialized;

  ShownTravelSession({
    required ShownTravelRepository shownTravelRepository,
    required MembersRepository membersRepository,
    required ParticipantsRepository participantsRepository,
    required GeneralManagerRepository gManagerRepository,
  }) : _shownTravelRepository = shownTravelRepository,
       _membersRepository = membersRepository,
       _participantsRepository = participantsRepository,
       _gManagerRepository = gManagerRepository {
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

      /* ここまで来てnotifyListenersする。このときtravelを見ている部分は動き出す */
      final groupId = _shownTravel!.groupId!;
      final travelId = _shownTravel!.travelId!;

      /**
       *  shown travelが存在する場合
       *  */
      _status = TravelSessionStatus.loadingMembers;
      notifyListeners();
      final membersRet = await _membersRepository.getAllMembers(groupId);
      if (membersRet.isSuccess) {
        _groupMembers = membersRet.data!;
      } else {
        _status = TravelSessionStatus.error;
        notifyListeners();
        return membersRet.toVoid();
      }
      notifyListeners();

      /* 参加者をロードする */
      _status = TravelSessionStatus.loadingParticipants;
      notifyListeners();
      final participantsRet = await _participantsRepository.getAllTravelers(
        groupId,
        travelId,
      );

      if (participantsRet.isSuccess) {
        _planner = participantsRet.data!;
      } else {
        _status = TravelSessionStatus.error;
        notifyListeners();
        return participantsRet.toVoid();
      }
      notifyListeners();

      _status = TravelSessionStatus.loadingGManager;
      notifyListeners();

      final gManagerRet = await _gManagerRepository.getGeneralManager(
        groupId,
        travelId,
      );
      if (gManagerRet.isSuccess) {
        _generalManager = gManagerRet.data;
      } else {
        _status = TravelSessionStatus.error;
        notifyListeners();
        return gManagerRet.toVoid();
      }
      notifyListeners();

      /* プランナーをロードする。まだやっていない */

      _status = TravelSessionStatus.ready;
      notifyListeners();
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
