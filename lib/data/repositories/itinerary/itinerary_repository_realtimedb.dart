import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

import '../../../CommonClass/ItinerarySection.dart';
import '../../model/itinerary_section/itinerary_section.dart';
import 'itinerary_repository.dart';

class ItineraryRepositoryRealtimeDb implements ItineraryRepository {
  final FirebaseDatabase _firebaseDatabase;

  ItineraryRepositoryRealtimeDb({required FirebaseDatabase firebaseDatabase})
    : _firebaseDatabase = firebaseDatabase;

  FirebaseDatabaseService<ItinerarySection> _service({
    required String groupId,
    required String travelId,
  }) {
    return FirebaseDatabaseService(database: _firebaseDatabase, path: FirebaseDatabasePaths.group(groupId).travels.travel(travelId).itinerary, fromJson: fromJson, toJson: toJson)
  }

  @override
  Stream<List<ItinerarySection>> watchItinerarySections(
    String groupId,
    String travelId,
  ) {}

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
