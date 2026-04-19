import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/model/itinerary_on_edit/itinerary_on_edit.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

import '../../model/itinerary_section/itinerary_section.dart';
import 'itinerary_repository.dart';

class ItineraryRepositoryRealtimeDb implements ItineraryRepository {
  final FirebaseDatabase _firebaseDatabase;

  ItineraryRepositoryRealtimeDb({required FirebaseDatabase firebaseDatabase})
    : _firebaseDatabase = firebaseDatabase;

  FirebaseDatabaseService<ItinerarySection> _sectionsService({
    required String groupId,
    required String travelId,
  }) {
    return FirebaseDatabaseService(
      database: _firebaseDatabase,
      path:
          FirebaseDatabasePaths.group(
            groupId,
          ).travels.travel(travelId).itinerary.sections.toString(),
      fromJson: ItinerarySection.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  @override
  Stream<List<ItinerarySection>> watchItinerarySections({
    required String groupId,
    required String travelId,
  }) {
    final service = _sectionsService(groupId: groupId, travelId: travelId);
    return service.streamList();
  }

  @override
  Future<List<ItinerarySection>> getItinerarySections({
    required String groupId,
    required String travelId,
  }) async {
    // TODO: implement getItinerarySections
    throw AppException("Not implemented yet!");
  }

  @override
  Future<void> saveItinerarySections({
    required String groupId,
    required String travelId,
    required List<ItinerarySection> sections,
  }) async {
    // TODO: implement saveItinerarySections
    throw AppException("No implemented yet!");
  }

  FirebaseDatabaseService<ItineraryOnEdit> _onEditService({
    required String groupId,
    required String travelId,
  }) {
    return FirebaseDatabaseService(
      database: _firebaseDatabase,
      path:
          FirebaseDatabasePaths.group(
            groupId,
          ).travels.travel(travelId).itinerary.onEdit.toString(),
      fromJson: ItineraryOnEdit.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  @override
  Future<ItineraryOnEdit?> getItineraryOnEdit({
    required String groupId,
    required String travelId,
  }) async {
    final service = _onEditService(groupId: groupId, travelId: travelId);
    return service.get();
  }

  @override
  Future<void> setItineraryOnEdit({
    required String groupId,
    required String travelId,
    required ItineraryOnEdit itineraryOnEdit,
  }) async {
    final service = _onEditService(groupId: groupId, travelId: travelId);
    await service.set(itineraryOnEdit);
  }

  @override
  Future<void> removeItineraryOnEdit({
    required String groupId,
    required String travelId,
  }) async {
    final service = _onEditService(groupId: groupId, travelId: travelId);
    await service.delete();
  }
}
