import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';
import 'package:my_travel_app/data/repositories/participants/participants_repository.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/domain/use_cases/get_user_travels_use_case.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/itinerary_store.dart';
import 'package:my_travel_app/ui/main/expenses/selectable_traveler.dart';

import '../../../../../data/model/travel/shown_travel_basic/shown_travel_basic.dart';

class TravelSelectViewModel extends ChangeNotifier {
  final GetUserTravelsUseCase _getUserTravelsUseCase;
  final AppSession _appSession;
  final ShownTravelSession _travelSession;
  final ItineraryStore _itineraryStore;
  final UserSettingsRepository _userSettingsRepository;
  final String? userRole;
  final GroupMembersRepository _groupMembersRepository;
  final ParticipantsRepository _participantsRepository;

  TravelSelectViewModel({
    required AppSession appSession,
    required ShownTravelSession travelSession,
    required ItineraryStore itineraryStore,
    required GetUserTravelsUseCase getUserTravelsUseCase,
    required UserSettingsRepository userSettingsRepository,
    required GroupMembersRepository groupMembersRepository,
    required ParticipantsRepository participantsRepository,
    this.userRole /* やり方汚いけどどうせまた作り直すからとりあえずこれでいいや。 */,
  }) : _getUserTravelsUseCase = getUserTravelsUseCase,
       _appSession = appSession,
       _travelSession = travelSession,
       _itineraryStore = itineraryStore,
       _userSettingsRepository = userSettingsRepository,
       _groupMembersRepository = groupMembersRepository,
       _participantsRepository = participantsRepository {
    initialize();
  }

  Map<String, Map<String, String>>? _userTravels;

  Map<String, Map<String, String>>? get userTravels => _userTravels;

  String? _selectedTravelId;

  String? get selectedTravelId => _selectedTravelId;

  Map<String, Map<String, TravelerCore>> _cachedGroupMembers = {};

  List<SelectableTraveler> _selectableParticipants = [];

  List<SelectableTraveler> get selectableParticipants => _selectableParticipants;

  Future<void> initialize() async {
    _selectedTravelId = _travelSession.currentTravel?.travelId;

    final uid = _appSession.currentUser!.uid;
    _userTravels = await _getUserTravelsUseCase.getUserTravelsWithNames(uid);
    notifyListeners();
    setTravelers();
  }

  void setSelectTravelId(String travelId) {
    _selectedTravelId = travelId;
    notifyListeners();
  }

  ResultInfo switchToSelectedTravel() {
    if (_itineraryStore.editMode) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "しおりがプランナーモードになっています。編集を終わらせてから表示旅行を変えてください"));
    }

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
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "旅行IDからグループIDを取得できませんでした。おそらくコーディングエラーです。"));
    }

    final newTravel = ShownTravelBasic(groupId: groupId, travelId: travelId);
    _travelSession.setShownTravel(newTravel);

    /// awaitはしない
    _userSettingsRepository.setShownTravel(_appSession.currentUser!.uid, newTravel);
    /* ShownTravelを設定する */
    return ResultInfo.success();
  }

  String? getGroupIdFromTravel(String travelId) {
    if (_userTravels == null) return null;
    /* travelIdからgroupIdを逆に検索 */
    String? groupId;
    for (final travelMap in _userTravels!.entries) {
      if (travelMap.value.containsKey(travelId)) {
        groupId = travelMap.key;
        break;
      }
    }
    return groupId;
  }

  Future<void> setTravelers() async {
    if (_selectedTravelId == null) {
      _selectableParticipants = [];
      notifyListeners();
      return;
    }

    final String localTravelId = _selectedTravelId!;

    if (_userTravels == null) {
      print("travels are not loaded");
      return;
    }

    /* travelIdからgroupIdを逆に検索 */
    String? groupId = getGroupIdFromTravel(localTravelId);
    if (groupId == null) {
      print("This is not possible");
      return;
    }

    /* 一旦初期化する */
    _selectableParticipants = [];
    notifyListeners();

    print("Selected travelId GroupId =$groupId");
    /* グループメンバーを取得する */
    bool doneNotify = false;
    if (_cachedGroupMembers[groupId] == null) {
      try {
        _cachedGroupMembers[groupId] = await _groupMembersRepository.getAllGroupMembers(groupId);

        if (localTravelId == _selectedTravelId) {
          /* 非同期処理中にユーザーが別の旅行を選択してしまった場合はおかしくなるので、ここでチェックをいれる */
          /* 変わっていなかったら値をいれる */
          _selectableParticipants = createSelectableParticipants(_cachedGroupMembers[groupId]!);
          doneNotify = true;
          notifyListeners();
        } else {}
      } catch (e) {
        print("${e.toString()}");
      }
    } else {
      /* Do Nothing */
      if (!doneNotify) {
        print("All ready loaded ${groupId}");
        /* 初回ですでにnotifyしている場合はいらない */
        _selectableParticipants = createSelectableParticipants(_cachedGroupMembers[groupId]!);
        notifyListeners();
      }
    }
  }

  List<SelectableTraveler> createSelectableParticipants(Map<String, TravelerCore> gMembers) {
    print("createSelectableParticipants called");
    return gMembers.entries
        .map((entry) => SelectableTraveler(traveler: TravelerBasic(core: entry.value), isChecked: true))
        .toList();
  }

  void switchChecked(int index) {
    _selectableParticipants[index] = _selectableParticipants[index].copyWith(
      isChecked: !_selectableParticipants[index].isChecked,
    );
    notifyListeners();
  }

  Future<ResultInfo> setParticipants() async {
    if (_selectableParticipants.length == 0) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "参加者候補リストがロードされていません"));
    }

    if (_selectedTravelId == null) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "旅行が選択されていません"));
    }
    final travelId = _selectedTravelId!;

    try {
      final groupId = getGroupIdFromTravel(travelId);
      if (groupId == null) {
        return ResultInfo.failed(error: ErrorInfo(errorMessage: "不正なグループIDです"));
      }

      /* 参加者を作る */
      Map<String, TravelerCore> participants = {};
      for (final sTraveler in _selectableParticipants) {
        if (sTraveler.isChecked) {
          participants[sTraveler.traveler.core.uid] = sTraveler.traveler.core;
        }
      }
      if (participants.isEmpty) {
        return ResultInfo.failed(error: ErrorInfo(errorMessage: "参加者を選択してください"));
      }
      ;
      await _participantsRepository.saveAllTravelers(
        groupId: groupId,
        travelId: travelId,
        travelers: participants,
      );
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }
}
