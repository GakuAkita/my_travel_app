abstract class JoinedGroupsRepository {
  Future<List<String>> getJoinedGroupIds(String uid);

  Future<void> addJoinedGroup(String uid, String groupId);

  Future<void> removeJoinedGroup(String uid, String groupId);
}
