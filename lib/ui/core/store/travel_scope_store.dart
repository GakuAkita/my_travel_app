import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/core/utils/CheckShownTravelBasic.dart';
import 'package:my_travel_app/data/repositories/group_members/group_members_repository.dart';
import 'package:my_travel_app/data/repositories/user_settings/user_settings_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/date_state.dart';

import '../../../data/model/traveler/traveler_basic.dart';

/// 画面に関わらず、旅行ごとに持っているもの。
class TravelScopeStore extends ChangeNotifier {
  final ShownTravelSession _session;
  final GroupMembersRepository _groupMembersRepository;
  final UserSettingsRepository _userSettingsRepository;

  TravelScopeStore({
    required ShownTravelSession session,
    required GroupMembersRepository groupMembersRepository,
    required UserSettingsRepository userSettingsRepository,
  }) : _session = session,
       _groupMembersRepository = groupMembersRepository,
       _userSettingsRepository = userSettingsRepository {
    print("TravelScopeViewModel was created. hashCode=${hashCode}");

    _session.addListener(_refresh);
  }

  void _refresh() async {
    print("TravelScopeStore detected change in ShownTravelSession.");
    if (!_session.initialized) {
      /**
       * travelSessionはログアウトしない限りは作り直されることはないので、
       * 一度trueになればそれ以降ずっとtrue
       */
      print("travelSession not initialized!! in TravelScopeStore");
      return;
    }

    try {
      /* ここに来た時点でTravelSessionは初期化されている */
    } finally {}
  }

  /**
   *  保持しているデータ
   *  基本的に外から参照される前提
   *  */

  DataState<Map<String, TravelerBasic>> _allGroupMembers = const DataState();

  DataState<Map<String, TravelerBasic>> get allGroupMembers => _allGroupMembers;

  DataState<String?> _generalManager = const DataState();

  DataState<String?> get generalManager => _generalManager;

  DataState<Map<String, TravelerBasic>> _participants = const DataState();

  DataState<Map<String, TravelerBasic>> get participants => _participants;

  /* sessionに紐づいているから他の旅行の取る場面はないと想定。 */
  Future<void> _refreshAllGroupMembers() async {
    if (_session.currentTravel == null) {
      _allGroupMembers = const DataState(
        data: {},
        isLoading: false,
        error: null,
      );
      return;
    }
    if (!checkIsShownTravelValid(_session.currentTravel!).isSuccess) {
      _allGroupMembers = DataState(
        isLoading: false,
        error: ErrorInfo(
          errorMessage: "Invalid shown travel. Probably Coding error.",
        ),
      );
      return;
    }

    /* 旅行はnullでもなく値がちゃんと入っている */
  }

  @override
  void dispose() {
    print("TravelScopeStore was disposed: hashcode=${hashCode}");
    // TODO: implement dispose
    _session.removeListener(_refresh);
    super.dispose();
  }
}
