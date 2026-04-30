import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/core/utils/CheckShownTravelBasic.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/itinerary/itinerary_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/data_state.dart';

import '../../../data/model/itinerary_section/itinerary_section.dart';

class ItineraryStore extends ChangeNotifier {
  ItineraryRepository _itineraryRepository;
  ShownTravelSession _travelSession;

  bool _storeInitialized = false;

  bool get storeInitialized => _storeInitialized;

  bool _subscriptionFirst = false;

  bool get subscriptionFirst => _subscriptionFirst;

  DataState<List<ItinerarySection>> _itinerarySections = DataState();

  DataState<List<ItinerarySection>> get itinerarySections => _itinerarySections;

  StreamSubscription<List<ItinerarySection>>? _subscription;

  bool _editMode = false;

  bool get editMode => _editMode;

  void setEditMode(bool value) {
    _editMode = value; /* notifyはViewModelが側でやる */
  }

  String? _groupId;
  String? _travelId;

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
      if (_travelSession.currentTravel != null) {
        _groupId = _travelSession.currentTravel!.groupId!;
        _travelId = _travelSession.currentTravel!.travelId!;
      } else {
        _groupId = null;
        _travelId = null;
        return;
      }

      /* travelIdがnullの場合はここまで来ない */
      _refreshItinerarySections(travel: _travelSession.currentTravel!, isLoadingNotify: true);
    } catch (e) {
      print("Error in ItineraryStore: ${e.toString()}");
    }
  }

  void _refreshItinerarySections({required ShownTravelBasic travel, bool isLoadingNotify = true}) async {
    if (!checkIsShownTravelValid(travel).isSuccess) {
      _itinerarySections = DataState(
        isLoading: false,
        error: ErrorInfo(errorMessage: "Invalid shown travel"),
      );
      return;
    }

    if (!_subscriptionFirst && _storeInitialized) {
      /* なんでこのブロックが必要か忘れてしまった、、 */
      /* 複数回呼ばれたときの対策か。 */
      print("Store is already initialized and subscription doesn't arrive yet.");
      return;
    }

    /* 前のsubscriptionを破棄 */
    _subscriptionFirst = false;

    _itinerarySections = const DataState(isLoading: true, error: null);
    if (isLoadingNotify) {
      notifyListeners();
    }

    print("Add subscription to ItineraryRepository");
    _subscription = _itineraryRepository
        .watchItinerarySections(groupId: _groupId!, travelId: _travelId!)
        .listen(
          (data) {
            print("Listened ItineraryRepository data updated.");
            _itinerarySections = DataState(data: data, isLoading: false);
            _subscriptionFirst = true;
            notifyListeners();
          },
          onError: (e) {
            print("Error in ItineraryStore: ${e.toString()}");
            _itinerarySections = DataState(isLoading: false, error: ErrorInfo(errorMessage: e.toString()));
            _subscriptionFirst = true;
            notifyListeners();
          },
        );
  }

  @override
  void dispose() {
    print("ItineraryStore was disposed. hashCode=${hashCode}");
    // TODO: implement dispose
    _travelSession.removeListener(_refresh);
    super.dispose();
  }
}
