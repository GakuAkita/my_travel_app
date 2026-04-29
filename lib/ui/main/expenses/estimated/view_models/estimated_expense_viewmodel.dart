import 'package:flutter/material.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/itinerary_store.dart';
import 'package:my_travel_app/ui/core/store/travel_scope_store.dart';

class EstimatedExpenseViewModel extends ChangeNotifier {
  final ShownTravelSession _travelSession;
  final ItineraryStore _itineraryStore;
  final TravelScopeStore _travelScopeStore;

  double _estimatedExpense = 0.0;

  double get estimatedExpense => _estimatedExpense;

  double _estimatedExpenseFromManual = 0.0;

  double get estimatedExpenseFromManual => _estimatedExpenseFromManual;

  double _estimatedExpenseFromItinerary = 0.0;

  double get estimatedExpenseFromItinerary => _estimatedExpenseFromItinerary;

  EstimatedExpenseViewModel({
    required ShownTravelSession travelSession,
    required ItineraryStore itineraryStore,
    required TravelScopeStore travelScopeStore,
  }) : _itineraryStore = itineraryStore,
       _travelSession = travelSession,
       _travelScopeStore = travelScopeStore {}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
