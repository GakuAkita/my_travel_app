import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';

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
