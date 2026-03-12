import '../../model/traveler/traveler_core/traveler_core.dart';

/**
 * 旅行の参加者の情報
 * 各travelごとに違う
 */
abstract class ParticipantsRepository {
  Future<Map<String, TravelerCore>> getAllTravelers(
    String groupId,
    String travelId,
  );

  Future<void> saveAllTravelers(
    String groupId,
    String travelId,
    Map<String, TravelerCore> travelers,
  );
}
