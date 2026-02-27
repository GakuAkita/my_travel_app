import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';

import 'itinerary_repository.dart';

class ItineraryRepositoryRealtimeDb implements ItineraryRepository {
  final FirebaseDatabase _firebaseDatabase;

  ItineraryRepositoryRealtimeDb({required FirebaseDatabase firebaseDatabase})
    : _firebaseDatabase = firebaseDatabase;

  @override
  Future<List<Map<String, dynamic>>> getItinerarySections(
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
    List<Map<String, dynamic>> sections,
  ) async {
    // TODO: implement saveItinerarySections
    throw AppException("No implemented yet!");
  }
}
