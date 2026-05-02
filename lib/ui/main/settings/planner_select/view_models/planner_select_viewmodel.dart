import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/data/repositories/planners/planners_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';

import '../../../../../CommonClass/ErrorInfo.dart';

class PlannerSelectViewModel extends ChangeNotifier {
  final ShownTravelSession _travelSession;
  final TravelScopeStore _travelScopeStore;
  final PlannersRepository _plannersRepository;

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
      final planners = _travelScopeStore.planners.data!;
    } else {
      /* エラーか初期化されていない */
    }
  }

  Future<ResultInfo> savePlanners(String groupId, String travelId, Map<String, TravelerCore> planners) async {
    try {
      await _plannersRepository.savePlanners(groupId, travelId, planners);
      /* TravelScopeではTravelScopeStoreで取得のコールだけする */
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
