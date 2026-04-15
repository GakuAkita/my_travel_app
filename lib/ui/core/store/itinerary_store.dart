import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ItinerarySection.dart';
import 'package:my_travel_app/core/utils/CheckShownTravelBasic.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/itinerary/itinerary_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/data_state.dart';

class ItineraryStore extends ChangeNotifier {
  ItineraryRepository _itineraryRepository;
  ShownTravelSession _travelSession;

  bool _storeInitialized = false;

  bool get storeInitialized => _storeInitialized;

  bool _subscriptionFirst = false;

  bool get subscriptionFirst => _subscriptionFirst;

  DataState<List<ItinerarySection>> _itinerarySections = DataState();

  DataState<List<ItinerarySection>> get itinerarySections => _itinerarySections;

  StreamSubscription<List<ItinerarySection>>? _itinerarySectionsSubscription;

  ItineraryStore({
    required ItineraryRepository itineraryRepository,
    required ShownTravelSession travelSession,
  }) : _itineraryRepository = itineraryRepository,
       _travelSession = travelSession {
    print("ItineraryStore was created. hashCode=${hashCode}");

    _travelSession.addListener(_refresh);
  }

  void _refresh() {
    try {
      if (!_travelSession.initialized) {
        print("travelSession not initialized!! in ItineraryStore");
        return;
      }
    } catch (e) {}
  }

  void _refreshItinerarySections({
    required ShownTravelBasic travel,
    bool isLoadingNotify = true,
  }) async {
    if (!checkIsShownTravelValid(travel).isSuccess) {
      _itinerarySections = DataState(
        isLoading: false,
        error: ErrorInfo(errorMessage: "Invalid shown travel"),
      );
      return;
    }

    if (!_subscriptionFirst && _storeInitialized) {
      /* なんでこのブロックが必要か忘れてしまった、、 */
      print(
        "Store is already initialized and subscription doesn't arrive yet.",
      );
      return;
    }

    /* 前のsubscriptionを破棄 */
    _subscriptionFirst = false;
  }

  @override
  void dispose() {
    print("ItineraryStore was disposed. hashCode=${hashCode}");
    // TODO: implement dispose
    _travelSession.removeListener(_refresh);
    super.dispose();
  }
}
