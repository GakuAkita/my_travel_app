import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/itinerary_store.dart';

import '../../../../../CommonClass/ResultInfo.dart';
import '../../../../../data/model/itinerary_section/itinerary_section.dart';
import '../../../../../data/repositories/itinerary/itinerary_repository.dart';

class ItineraryViewModel extends ChangeNotifier {
  final ItineraryStore _itineraryStore;
  final ItineraryRepository _itineraryRepository;
  final ShownTravelSession _travelSession;

  List<ItinerarySection> _itinerarySections = [];

  List<ItinerarySection> get itinerarySections => _itinerarySections;

  bool get isItineraryLoading => _itineraryStore.itinerarySections.isLoading;

  ShownTravelBasic? get travel => _travelSession.currentTravel;

  /**
   * Travelが変わったときは
   */
  ItineraryViewModel({
    required ItineraryRepository itineraryRepository,
    required ItineraryStore itineraryStore,
    required ShownTravelSession travelSession,
  }) : _itineraryRepository = itineraryRepository,
       _itineraryStore = itineraryStore,
       _travelSession = travelSession {
    print("ItineraryViewModel was created. code=${hashCode}");

    _itineraryStore.addListener(_itinerarySync);
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

  void printTest() {
    print("code=~${hashCode} travel=${travel.toString()}");
  }

  @override
  void dispose() {
    print("ItineraryViewModel was disposed. code=${hashCode}");

    _itineraryStore.removeListener(_itinerarySync);
    // TODO: implement dispose
    super.dispose();
  }
}
