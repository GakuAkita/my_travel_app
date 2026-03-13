import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';

abstract class PlannersRepository {
  Future<Map<String, TravelerCore>> getAllPlanners(
    String groupId,
    String travelId,
  );

  Future<void> setPlanners(
    String groupId,
    String travelId,
    Map<String, TravelerCore> planners,
  );
}
