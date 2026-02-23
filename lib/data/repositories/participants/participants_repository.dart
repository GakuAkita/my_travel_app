import 'package:my_travel_app/CommonClass/ResultInfo.dart';

import '../../model/traveler/traveler_basic/traveler_basic.dart';

/**
 * 旅行の参加者の情報
 * 各travelごとに違う
 */
abstract class ParticipantsRepository {
  Future<ResultInfo<Map<String, TravelerBasic>>> getAllTravelers(
    String groupId,
    String travelId,
  );

  Future<ResultInfo<void>> saveAllTravelers(
    String groupId,
    String travelId,
    Map<String, TravelerBasic> travelers,
  );
}
