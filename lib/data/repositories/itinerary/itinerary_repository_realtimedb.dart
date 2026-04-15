import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';

import '../../../CommonClass/ItinerarySection.dart';
import 'itinerary_repository.dart';

class ItineraryRepositoryRealtimeDb implements ItineraryRepository {
  final FirebaseDatabase _firebaseDatabase;

  ItineraryRepositoryRealtimeDb({required FirebaseDatabase firebaseDatabase})
    : _firebaseDatabase = firebaseDatabase;

  @override
  Stream<List<ItinerarySection>> watchItinerarySections(
    String groupId,
    String travelId,
  ) {
    // TODO: implement watchItinerarySections
    throw UnimplementedError();
  }

  @override
  Future<List<ItinerarySection>> getItinerarySections(
    String groupId,
    String travelId,
  ) async {
    // TODO: implement getItinerarySections
    throw AppException("Not implemented yet!");
  }

  @override
  Future<void> saveItinerarySections(
    String groupId,
    String travelId,
    List<ItinerarySection> sections,
  ) async {
    // TODO: implement saveItinerarySections
    throw AppException("No implemented yet!");
  }
}
