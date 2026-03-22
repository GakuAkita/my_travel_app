import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/repositories/joined_groups/joined_groups_repository.dart';
import 'package:my_travel_app/data/repositories/travel_keys/travel_keys_repository.dart';
import 'package:my_travel_app/state/session/app_session.dart';
import 'package:my_travel_app/ui/core/store/data_state.dart';

class TravelCreateViewModel extends ChangeNotifier {
  final AppSession _appSession;
  final TravelKeysRepository _travelKeysRepository;
  final JoinedGroupsRepository _joinedGroupsRepository;

  DataState<List<String>> _joinedGroupIds = DataState(data: []);

  DataState<List<String>> get joinedGroupIds => _joinedGroupIds;

  late final String _uid;

  TravelCreateViewModel({
    required AppSession appSession,
    required TravelKeysRepository travelKeysRepository,
    required JoinedGroupsRepository joinedGroupsRepository,
  }) : _appSession = appSession,
       _travelKeysRepository = travelKeysRepository,
       _joinedGroupsRepository = joinedGroupsRepository {
    _uid = _appSession.currentUser!.uid;
    getJoinedGroups();
  }

  Future<void> getJoinedGroups() async {
    try {
      final groupIds = await _joinedGroupsRepository.getJoinedGroupIds(_uid);
      _joinedGroupIds = DataState(data: groupIds);
    } catch (e) {
      _joinedGroupIds = DataState(error: ErrorInfo(errorMessage: e.toString()));
    } finally {
      notifyListeners();
    }
  }

  Future<ResultInfo> createTravel({
    required String groupId,
    required String travelName,
  }) {
    try {
      /* travelKeyに追加する */
      /* nameとともに、$groupId/travels配下に追加する */
    } catch (e) {}
    return ResultInfo.success();
  }
}
