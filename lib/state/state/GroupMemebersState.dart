import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';

/**
 * グループに紐づくデータを管理
 */
class GroupMembersState extends ChangeNotifier {
  final GroupMembersRepository _groupMembersRepository;
  final ShownTravelSession _travelSession;

  Map<String, TravelerBasic> _groupMembers = {};

  Map<String, TravelerBasic> get groupMembers => _groupMembers;

  GroupMembersState({
    required ShownTravelSession travelSession,
    required GroupMembersRepository groupMembersRepository,
  }) : _travelSession = travelSession,
       _groupMembersRepository = groupMembersRepository {
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

  @override
  void dispose() {
    print("GroupMembersState was disposed");
    // TODO: implement dispose
    super.dispose();
  }
}
