import 'package:firebase_database/firebase_database.dart';

import '../../../CommonClass/ResultInfo.dart';
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
  Future<ResultInfo<List<Map<String, dynamic>>>> getItinerarySections(
    String groupId,
    String travelId,
  ) async {
    // TODO: implement getItinerarySections
    throw UnimplementedError();
  }

  @override
  Future<ResultInfo<void>> saveItinerarySections(
    String groupId,
    String travelId,
    List<Map<String, dynamic>> sections,
  ) async {
    // TODO: implement saveItinerarySections
    throw UnimplementedError();
  }
}
