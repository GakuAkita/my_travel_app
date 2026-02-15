import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';

/**
 * グループに紐づくデータを管理
 */
class GroupMembersState extends ChangeNotifier {
  final GroupMembersRepository _groupMembersRepository;

  Map<String, TravelerBasic> _groupMembers = {};

  Map<String, TravelerBasic> get groupMembers => _groupMembers;

  GroupMembersState({required GroupMembersRepository groupMembersRepository})
    : _groupMembersRepository = groupMembersRepository {
    print("GroupMembersState was created");
  }

  Future<ResultInfo<void>> getAllGroupMembers(String groupId) async {
    final result = await _groupMembersRepository.getAllGroupMembers(groupId);
    if (result.isSuccess) {
      _groupMembers = result.data!;
      notifyListeners();
    }

    return result.toVoid();
  }
}
