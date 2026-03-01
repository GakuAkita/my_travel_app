import 'package:my_travel_app/data/repositories/group_keys/group_keys_repository.dart';
import 'package:my_travel_app/data/repositories/joined_groups/joined_groups_repository.dart';

class GetUserTravelsUseCase {
  final GroupKeysRepository _groupKeysRepository;
  final JoinedGroupsRepository _joinedGroupsRepository;

  GetUserTravelsUseCase({
    required GroupKeysRepository groupKeysRepository,
    required JoinedGroupsRepository joinedGroupsRepository,
  }) : _groupKeysRepository = groupKeysRepository,
       _joinedGroupsRepository = joinedGroupsRepository;

  /// グループIDがキーで、キーの値が旅行IDのリスト
  Future<Map<String, List<String>>> getUserTravels(String uid) async {
    final joinedGroupsIds = await _joinedGroupsRepository.getJoinedGroupIds(
      uid,
    );
    Map<String, List<String>> travelsMap = {};
    Future.wait(
      joinedGroupsIds.map((groupId) async {
        final travelIds = await _groupKeysRepository.getGroupTravelIds(groupId);
        travelsMap[groupId] = travelIds;
      }),
    );
    return travelsMap;
  }
}
