import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/Loadable.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';
import 'package:my_travel_app/ui/core/store/date_state.dart';

import '../../../data/model/traveler/traveler_basic.dart';

/// 画面に関わらず、旅行ごとに持っているもの。
class TravelScopeStore extends ChangeNotifier {
  final ShownTravelSession _session;

  TravelScopeStore({required ShownTravelSession session}) : _session = session {
    print("TravelScopeViewModel was created. hashCode=${hashCode}");
  }

  /**
   *  保持しているデータ
   *  基本的に外から参照される前提
   *  */

  DataState<Map<String, TravelerBasic>> _allGroupMembers = const DataState();

  DataState<Map<String, TravelerBasic>> get allGroupMembers => _allGroupMembers;

  Loadable<String?> _generalManager = const NotLoaded();

  Loadable<String?> get generalManager => _generalManager;

  Loadable<Map<String, TravelerBasic>> _participants = const NotLoaded();

  Loadable<Map<String, TravelerBasic>> get participants => _participants;

  @override
  void dispose() {
    print("TravelScopeStore was disposed: hashcode=${hashCode}");
    // TODO: implement dispose
    super.dispose();
  }
}
