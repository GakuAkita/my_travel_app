import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/data/repositories/planners/planners_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';
import 'package:my_travel_app/ui/main/expenses/selectable_traveler.dart';

import '../../../../../CommonClass/ErrorInfo.dart';

class PlannerSelectViewModel extends ChangeNotifier {
  final ShownTravelSession _travelSession;
  final TravelScopeStore _travelScopeStore;
  final PlannersRepository _plannersRepository;

  bool get isStoreLoading => _travelScopeStore.planners.isLoading;

  Map<String, TravelerCore> _planners = {};

  Map<String, TravelerCore> get planners => _planners;

  Map<String, TravelerBasic> _groupMembers = {};

  Map<String, TravelerBasic> get groupMembers => _groupMembers;

  Map<String, SelectableTraveler> _selectablePlanners = {};

  Map<String, SelectableTraveler> get selectablePlanners => _selectablePlanners;

  PlannerSelectViewModel({
    required ShownTravelSession travelSession,
    required TravelScopeStore travelScopeStore,
    required PlannersRepository plannersRepository,
  }) : _travelSession = travelSession,
       _travelScopeStore = travelScopeStore,
       _plannersRepository = plannersRepository;

  Future<void> initialize() async {
    final groupId = _travelSession.currentTravel!.groupId!;
    final travelId = _travelSession.currentTravel!.travelId!;

    if (_travelScopeStore.planners.hasData) {
      _planners = _travelScopeStore.planners.data!;
    } else {
      /* エラーかまだ初期化されていない */
    }

    if (_travelScopeStore.allGroupMembers.hasData) {
      _groupMembers = _travelScopeStore.allGroupMembers.data!;
    } else {
      /* エラーかまだ初期化されていない */
    }

    /* 最初のSelectableの状態を作る */
    _selectablePlanners = _groupMembers.map(
      (key, traveler) =>
          MapEntry(key /* Travelerのuidになっている */, SelectableTraveler(traveler: traveler, isChecked: false)),
    );

    /* plannersに設定されているものは最初からチェック入れる */
    for (final planner in _planners.entries) {
      if (_selectablePlanners.containsKey(planner.key)) {
        _selectablePlanners[planner.key] = _selectablePlanners[planner.key]!.copyWith(isChecked: true);
      }
    }
    notifyListeners();
  }

  ResultInfo onSelectChanged(String uid, bool isChecked) {
    try {
      if (_selectablePlanners.containsKey(uid)) {
        _selectablePlanners[uid] = _selectablePlanners[uid]!.copyWith(isChecked: isChecked);
        return ResultInfo.success();
      }
      return ResultInfo.failed(error: ErrorInfo(errorMessage: "選択に失敗しました"));
    } finally {
      notifyListeners();
    }
  }

  Future<ResultInfo> savePlanners() async {
    try {
      final groupId = _travelSession.currentTravel!.groupId!;
      final travelId = _travelSession.currentTravel!.travelId!;

      Map<String, TravelerCore> data = {};
      for (final traveler in _selectablePlanners.entries) {
        if (traveler.value.isChecked) {
          data[traveler.key] = traveler.value.traveler.core;
        }
      }
      return await _savePlanners(groupId, travelId, data);
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  Future<ResultInfo> _savePlanners(
    String groupId,
    String travelId,
    Map<String, TravelerCore> planners,
  ) async {
    try {
      await _plannersRepository.savePlanners(groupId, travelId, planners);
      /* TravelScopeではTravelScopeStoreで取得のコールだけする */
      _travelScopeStore.refreshPlanners();
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
