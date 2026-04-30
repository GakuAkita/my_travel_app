import 'package:my_travel_app/data/repositories/joined_groups/joined_groups_repository.dart';
import 'package:my_travel_app/data/repositories/travel/travel_repository.dart';
import 'package:my_travel_app/data/repositories/travel_keys/travel_keys_repository.dart';

/// あるユーザーの参加しているグループを取ってきて
/// そこに連なっている旅行idを取得して旅行名を取る
class GetUserTravelsUseCase {
  final TravelKeysRepository _travelKeysRepository;
  final JoinedGroupsRepository _joinedGroupsRepository;
  final TravelRepository _travelRepository;

  GetUserTravelsUseCase({
    required TravelKeysRepository travelKeysRepository,
    required JoinedGroupsRepository joinedGroupsRepository,
    required TravelRepository travelRepository,
  }) : _travelKeysRepository = travelKeysRepository,
       _joinedGroupsRepository = joinedGroupsRepository,
       _travelRepository = travelRepository;

  /// グループIDがキーで、キーは旅行
  Future<Map<String, List<String>>> getUserTravels(String uid) async {
    final joinedGroupsIds = await _joinedGroupsRepository.getJoinedGroupIds(
      uid,
    );

    final entries = await Future.wait(
      joinedGroupsIds.map((groupId) async {
        final travelIds = await _travelKeysRepository.getGroupTravelIds(
          groupId,
        );
        return MapEntry(groupId, travelIds);
      }),
    );

    return Map.fromEntries(entries);
  }

  /// 旅行名も取りたいときはこっち
  /// シンプルにgetUserTravelsを実行後にそれぞれ名前を取りに行ってもいいが、
  /// 名前も並列で取ったほうが早い
  Future<Map<String, Map<String, String>>> getUserTravelsWithNames(
    String uid,
  ) async {
    final joinedGroupIds = await _joinedGroupsRepository.getJoinedGroupIds(uid);

    final groupEntries = await Future.wait(
      joinedGroupIds.map((groupId) async {
        final travelIds = await _travelKeysRepository.getGroupTravelIds(
          groupId,
        );

        final travelEntries = await Future.wait(
          travelIds.map((travelId) async {
            final travelName = await _travelRepository.getTravelName(
              groupId: groupId,
              travelId: travelId,
            );

            return MapEntry(travelId, travelName);
          }),
        );

        return MapEntry(groupId, Map.fromEntries(travelEntries));
      }),
    );

    return Map.fromEntries(groupEntries);
  }
}
