import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/data_state.dart';
import 'package:my_travel_app/ui/core/store/itinerary_store.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';

import '../../../../../CommonClass/ResultInfo.dart';
import '../../../../../data/model/itinerary_section/itinerary_section.dart';
import '../../../../../data/repositories/itinerary/itinerary_repository.dart';

class ItineraryViewModel extends ChangeNotifier {
  final ItineraryStore _itineraryStore;
  final UserSettingsRepository _userSettingsRepository;
  final TravelScopeStore _travelScopeStore;
  final ItineraryRepository _itineraryRepository;
  final ShownTravelSession _travelSession;
  final AppSession _appSession;

  List<ItinerarySection> _itinerarySections = [];

  List<ItinerarySection> get itinerarySections => _itinerarySections;

  bool get isItineraryLoading => _itineraryStore.itinerarySections.isLoading;

  ShownTravelBasic? get travel => _travelSession.currentTravel;

  DataState<String?> _roleState = const DataState();

  DataState<String?> get roleState => _roleState;

  /**
   * Travelが変わったときは
   */
  ItineraryViewModel({
    required ItineraryRepository itineraryRepository,
    required UserSettingsRepository userSettingsRepository, //adminかどうかを判断する
    required ItineraryStore itineraryStore,
    required TravelScopeStore travelScopeStore,
    required ShownTravelSession travelSession,
    required AppSession appSession,
  }) : _itineraryRepository = itineraryRepository,
       _userSettingsRepository = userSettingsRepository,
       _itineraryStore = itineraryStore,
       _travelScopeStore = travelScopeStore,
       _travelSession = travelSession,
       _appSession = appSession {
    print("ItineraryViewModel was created. code=${hashCode}");

    _itineraryStore.addListener(_itinerarySync);
    _travelScopeStore.addListener(_travelScopeSync);
  }

  void _itinerarySync() {
    try {
      if (_itineraryStore.itinerarySections.hasError) {
        print("エラーを出したい");
      } else if (_itineraryStore.itinerarySections.hasData) {
        _itinerarySections = _itineraryStore.itinerarySections.data!;
      } else {
        /* エラーでもないけどdataがない */
        print("Probably coding error>>");
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchUserRole() async {
    try {
      final String uid = _appSession.currentUser!.uid;
      final role = await _userSettingsRepository.getUserRole(uid);
      _roleState = DataState(data: role);
    } catch (e) {
      _roleState = DataState(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  void _travelScopeSync() {
    try {} finally {
      notifyListeners();
    }
  }

  Future<ResultInfo<void>> saveItinerary() async {
    /* ローカルの中のitineraryを保存する */
    return ResultInfo.success();
  }

  Future<ResultInfo<void>> saveItineraryForTravel(
    String groupId,
    String travelId,
    List<ItinerarySection> sections /* dynamicでいいのか？？ */,
  ) async {
    try {
      await _itineraryRepository.saveItinerarySections(
        groupId: groupId,
        travelId: travelId,
        sections: sections,
      );
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  @override
  void dispose() {
    print("ItineraryViewModel was disposed. code=${hashCode}");

    _itineraryStore.removeListener(_itinerarySync);
    _travelScopeStore.removeListener(_travelScopeSync);
    // TODO: implement dispose
    super.dispose();
  }
}
