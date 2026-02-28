import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ItinerarySection.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';

import '../../../../../CommonClass/ResultInfo.dart';
import '../../../../../data/repositories/itinerary/itinerary_repository.dart';

class ItineraryViewModel extends ChangeNotifier {
  final ItineraryRepository _itineraryRepository;
  final ShownTravelSession _travelSession;

  List<ItinerarySection> _itinerarySections = [];

  List<ItinerarySection> get itinerarySections => _itinerarySections;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ShownTravelBasic? get travel => _travelSession.currentTravel;

  /**
   * Travelが変わったときは
   */
  ItineraryViewModel({
    required ItineraryRepository itineraryRepository,
    required ShownTravelSession travelSession,
  }) : _itineraryRepository = itineraryRepository,
       _travelSession = travelSession {
    print("ItineraryViewModel was created. code=${hashCode}");
  }

  Future<ResultInfo<void>> saveItinerary() async {
    /* ローカルの中のitineraryを保存する */
    return ResultInfo.success();
  }

  Future<ResultInfo<void>> saveItineraryForTravel(
    String groupId,
    String travelId,
    List<Map<String, dynamic>> sections /* dynamicでいいのか？？ */,
  ) async {
    try {
      await _itineraryRepository.saveItinerarySections(
        groupId,
        travelId,
        sections,
      );
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  Future<ResultInfo<List<Map<String, dynamic>>>> loadItineraryForTravel(
    String groupId,
    String travelId,
  ) async {
    try {
      await _itineraryRepository.getItinerarySections(groupId, travelId);
      return ResultInfo.success();
    } catch (e) {
      return ResultInfo.failed(error: ErrorInfo(errorMessage: e.toString()));
    }
  }

  Future<ResultInfo<void>> loadItineraryWithNotify() async {
    _isLoading = true;
    notifyListeners();

    //final ret = await loadItinerary();
    _isLoading = false;
    notifyListeners();
    return ResultInfo.success();
  }

  void printTest() {
    print("code=~${hashCode} travel=${travel.toString()}");
  }

  @override
  void dispose() {
    print("ItineraryViewModel was disposed. code=${hashCode}");
    // TODO: implement dispose
    super.dispose();
  }
}
