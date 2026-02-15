import 'package:flutter/widgets.dart';
import 'package:my_travel_app/CommonClass/ItinerarySection.dart';

import '../../../../../CommonClass/ResultInfo.dart';
import '../../../../../data/repositories/itinerary/itinerary_repository.dart';
import '../../../../../state/session/shown_travel_session.dart';

class ItineraryViewModel extends ChangeNotifier {
  final ItineraryRepository _itineraryRepository;
  final ShownTravelSession _travelSession;

  List<ItinerarySection> _itinerarySections = [];

  List<ItinerarySection> get itinerarySections => _itinerarySections;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ItineraryViewModel({
    required ItineraryRepository itineraryRepository,
    required ShownTravelSession travelSession,
  }) : _itineraryRepository = itineraryRepository,
       _travelSession = travelSession {
    print("ItineraryViewModel was created");
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
    final result = await _itineraryRepository.saveItinerarySections(
      groupId,
      travelId,
      sections,
    );
    return result.toVoid();
  }

  Future<ResultInfo<List<Map<String, dynamic>>>> loadItineraryForTravel(
    String groupId,
    String travelId,
  ) async {
    final result = await _itineraryRepository.getItinerarySections(
      groupId,
      travelId,
    );
    return result;
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
