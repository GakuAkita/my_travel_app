import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';
import 'package:my_travel_app/data/repositories/group_creator/group_creator_repository.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';
import 'package:my_travel_app/data/repositories/groups/groups_repository.dart';
import 'package:my_travel_app/data/repositories/joined_groups/joined_groups_repository.dart';
import 'package:my_travel_app/data/repositories/travel_keys/travel_keys_repository.dart';

/// グループの作成、削除を行う
/// NoSQLとRDBで勝手が違うから、場合によってはabstractした方が良い。
class CrudGroupUseCase {
  final GroupMembersRepository _groupMembersRepository;
  final JoinedGroupsRepository _joinedGroupsRepository;
  final GroupCreatorRepository _groupCreatorRepository;
  final GroupsRepository _groupsRepository;
  final TravelKeysRepository _travelKeysRepository;

  /// NoSQLベースで作っちゃっているな、、
  CrudGroupUseCase({
    required GroupMembersRepository groupMembersRepository,
    required JoinedGroupsRepository joinedGroupsRepository,
    required GroupCreatorRepository groupCreatorRepository,
    required GroupsRepository groupsRepository,
    required TravelKeysRepository travelKeyRepository,
  }) : _joinedGroupsRepository = joinedGroupsRepository,
       _groupMembersRepository = groupMembersRepository,
       _groupCreatorRepository = groupCreatorRepository,
       _groupsRepository = groupsRepository,
       _travelKeysRepository = travelKeyRepository;

  /* NoSQL専用かもしれん、、 */
  Future<void> createGroup(
    Map<String, TravelerCore> uids,
    TravelerCore creator,
    String groupId,
  ) async {
    final uidList = uids.keys;
    /* joined groupに追加 */
    await Future.wait([
      for (final id in uidList)
        _joinedGroupsRepository.addJoinedGroup(id, groupId),

      _groupMembersRepository.setGroupMembers(groupId, uids),
      _groupCreatorRepository.setGroupCreator(groupId, creator),
    ]);
  }

  Future<void> deleteGroup(String groupId) async {
    /* メンバーを取得して、 */
    final members = await _groupMembersRepository.getAllGroupMembers(groupId);
    final uidList = members.keys;

    await Future.wait([
      for (final id in uidList)
        _joinedGroupsRepository.removeJoinedGroup(id, groupId),
      _groupsRepository.deleteGroupsRepository(groupId),
      _travelKeysRepository.removeAllGroupTravelIds(groupId),
    ]);
    /* その後、 */
  }
}
