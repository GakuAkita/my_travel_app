import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/planners/planners_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

import '../../model/traveler/traveler_core/traveler_core.dart';

class PlannersRepositoryRealtimeDb implements PlannersRepository {
  final FirebaseDatabase _database;

  PlannersRepositoryRealtimeDb({required FirebaseDatabase database}) : _database = database;

  FirebaseDatabaseService<TravelerCore> _service(String groupId, String travelId) {
    return FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.group(groupId).travels.travel(travelId).planners,
      fromJson: TravelerCore.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  @override
  Future<Map<String, TravelerCore>> getAllPlanners(String groupId, String travelId) async {
    final service = _service(groupId, travelId);
    final data = await service.getAll();
    return data;
  }

  @override
  Future<void> savePlanners(String groupId, String travelId, Map<String, TravelerCore> planners) async {
    final service = _service(groupId, travelId);
    await service.setAll(planners);
  }
}
