import 'package:flutter/material.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/itinerary_store.dart';

class EstimatedExpenseViewModel extends ChangeNotifier {
  final ShownTravelSession _travelSession;
  final ItineraryStore _itineraryStore;

  EstimatedExpenseViewModel({
    required ShownTravelSession travelSession,
    required ItineraryStore itineraryStore,
  }) : _itineraryStore = itineraryStore,
       _travelSession = travelSession {}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
