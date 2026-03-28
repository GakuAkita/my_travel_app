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
import 'package:my_travel_app/ui/main/expenses/selectable_traveler.dart';

import '../../../../../data/model/travel/shown_travel_basic/shown_travel_basic.dart';

class TravelSelectViewModel extends ChangeNotifier {
  final GetUserTravelsUseCase _getUserTravelsUseCase;
  final AppSession _appSession;
  final ShownTravelSession _travelSession;
  final UserSettingsRepository _userSettingsRepository;
  final String? userRole;
  final GroupMembersRepository _groupMembersRepository;
  final ParticipantsRepository _participantsRepository;

  TravelSelectViewModel({
    required AppSession appSession,
    required ShownTravelSession travelSession,
    required GetUserTravelsUseCase getUserTravelsUseCase,
    required UserSettingsRepository userSettingsRepository,
    required GroupMembersRepository groupMembersRepository,
    required ParticipantsRepository participantsRepository,
    this.userRole /* やり方汚いけどどうせまた作り直すからとりあえずこれでいいや。 */,
  }) : _getUserTravelsUseCase = getUserTravelsUseCase,
       _appSession = appSession,
       _travelSession = travelSession,
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

  List<SelectableTraveler> get selectableParticipants =>
      _selectableParticipants;

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

    /// awaitはしない
    _userSettingsRepository.setShownTravel(
      _appSession.currentUser!.uid,
      newTravel,
    );
    /* ShownTravelを設定する */
    return ResultInfo.success();
  }

  Future<void> setTravelers() async {
    if (_selectedTravelId == null) {
      return;
    }

    final String localTravelId = _selectedTravelId!;

    if (_userTravels == null) {
      print("travels are not loaded");
      return;
    }

    /* travelIdからgroupIdを逆に検索 */
    String? groupId;
    for (final travelMap in _userTravels!.entries) {
      if (travelMap.value.containsKey(localTravelId)) {
        groupId = travelMap.key;
        break;
      }
    }
    if (groupId == null) {
      print("This is not possible");
      return;
    }

    /* 一旦初期化する */
    _selectableParticipants = [];
    notifyListeners();
    /* グループメンバーを取得する */
    if (_cachedGroupMembers[groupId] == null) {
      try {
        _cachedGroupMembers[groupId] = await _groupMembersRepository
            .getAllGroupMembers(groupId);
        if (localTravelId == _selectedTravelId) {
          /* 非同期処理中にユーザーが別の旅行を選択してしまった場合はおかしくなるので、ここでチェックをいれる */
          /* 変わっていなかったら値をいれる */
          _selectableParticipants = createSelectableParticipants(localTravelId);
          notifyListeners();
        }
      } catch (e) {
        print("${e.toString()}");
      }
    } else {
      /* Do Nothing */
      _selectableParticipants = createSelectableParticipants(localTravelId);
    }
  }

  List<SelectableTraveler> createSelectableParticipants(String travelId) {
    if (_cachedGroupMembers[travelId] == null) {
      return [];
    }

    return _cachedGroupMembers[travelId]!.entries
        .map(
          (entry) => SelectableTraveler(
            traveler: TravelerBasic(core: entry.value),
            isChecked: true,
          ),
        )
        .toList();
  }
}
