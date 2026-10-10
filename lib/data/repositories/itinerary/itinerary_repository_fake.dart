import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/model/itinerary_on_edit/itinerary_on_edit.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

import '../../model/itinerary_section/itinerary_section.dart';
import 'itinerary_repository.dart';

class ItineraryRepositoryFake implements ItineraryRepository {
  final FakeDatabase _database;

  ItineraryRepositoryFake({required FakeDatabase database}) : _database = database;

  ItineraryPath _itinerary(String groupId, String travelId) =>
      FirebaseDatabasePaths.group(groupId).travels.travel(travelId).itinerary;

  List<ItinerarySection> _toSections(String path) =>
      _database.getList(path).map(ItinerarySection.fromJson).toList();

  @override
  Stream<List<ItinerarySection>> watchItinerarySections({required String groupId, required String travelId}) {
    final path = _itinerary(groupId, travelId).sections;
    return _database.watch(path, (_) => _toSections(path));
  }

  @override
  Future<List<ItinerarySection>> getItinerarySections({required String groupId, required String travelId}) async =>
      _toSections(_itinerary(groupId, travelId).sections);

  @override
  Future<void> saveItinerarySections({
    required String groupId,
    required String travelId,
    required List<ItinerarySection> sections,
  }) async {
    final path = _itinerary(groupId, travelId).sections;
    _database.set(path, sections.isEmpty ? null : sections.map((e) => e.toJson()).toList());
  }

  @override
  Future<ItineraryOnEdit?> getItineraryOnEdit({required String groupId, required String travelId}) async {
    final json = _database.get(_itinerary(groupId, travelId).onEdit);
    if (json == null) return null;
    return ItineraryOnEdit.fromJson(Map<String, dynamic>.from(json));
  }

  @override
  Future<void> setItineraryOnEdit({
    required String groupId,
    required String travelId,
    required ItineraryOnEdit itineraryOnEdit,
  }) async => _database.set(_itinerary(groupId, travelId).onEdit, itineraryOnEdit.toJson());

  @override
  Future<void> removeItineraryOnEdit({required String groupId, required String travelId}) async =>
      _database.remove(_itinerary(groupId, travelId).onEdit);
}
