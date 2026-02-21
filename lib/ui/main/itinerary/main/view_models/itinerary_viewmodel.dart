import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ItinerarySection.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';

import '../../../../../CommonClass/ResultInfo.dart';
import '../../../../../data/repositories/itinerary/itinerary_repository.dart';

class ItineraryViewModel extends ChangeNotifier {
  final ItineraryRepository _itineraryRepository;

  List<ItinerarySection> _itinerarySections = [];

  List<ItinerarySection> get itinerarySections => _itinerarySections;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final ShownTravelBasic? travel;

  /**
   * Travelが変わったときは
   */
  ItineraryViewModel({
    required ItineraryRepository itineraryRepository,
    required ShownTravelBasic? travel,
  }) : _itineraryRepository = itineraryRepository,
       travel = travel {
    print(
      "ItineraryViewModel was created. travel=${travel?.travelId} group=${travel?.groupId}",
    );
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

  @override
  void dispose() {
    print("ItineraryViewModel was disposed");
    // TODO: implement dispose
    super.dispose();
  }
}
