import 'package:my_travel_app/data/repositories/planners/planners_repository.dart';

import '../../model/traveler/traveler_core/traveler_core.dart';

class PlannersRepositoryRealtimeDb implements PlannersRepository {
  @override
  Future<Map<String, TravelerCore>> getAllPlanners(
    String groupId,
    String travelId,
  ) async {
    // TODO: implement getAllPlanners
    return {};
  }

  @override
  Future<void> setPlanners(
    String groupId,
    String travelId,
    Map<String, TravelerCore> planners,
  ) {
    // TODO: implement setPlanners
    throw UnimplementedError();
  }
}
