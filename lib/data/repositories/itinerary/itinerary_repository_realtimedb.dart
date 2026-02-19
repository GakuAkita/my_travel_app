import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';

import 'itinerary_repository.dart';

class ItineraryRepositoryRealtimeDb implements ItineraryRepository {
  final FirebaseDatabase _firebaseDatabase;
  final String _userId;

  ItineraryRepositoryRealtimeDb({
    required FirebaseDatabase firebaseDatabase,
    required String userId,
  }) : _firebaseDatabase = firebaseDatabase,
       _userId = userId;

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
