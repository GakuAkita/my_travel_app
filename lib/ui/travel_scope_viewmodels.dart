import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/Loadable.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';

import '../data/model/traveler/traveler_basic.dart';

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
  late final ShownTravelBasic? travel;

  Loadable<Map<String, TravelerBasic>> _allGroupMembers = Loadable();

  Loadable<Map<String, TravelerBasic>> get allGroupMembers => _allGroupMembers;

  Loadable<String?> _generalManager = Loadable();

  Loadable<String?> get generalManager => _generalManager;

  Loadable<Map<String, TravelerBasic>> _participants = Loadable();

  Loadable<Map<String, TravelerBasic>> get participants => _participants;

  void updateAllGroupMembers(Map<String, TravelerBasic> members) {
    _allGroupMembers.value = members;
    _allGroupMembers.isLoaded = true;
    notifyListeners();
  }

  void updateGeneralManager(String? manager) {
    _generalManager.value = manager;
    _generalManager.isLoaded = true;
    notifyListeners();
  }

  void updateParticipants(Map<String, TravelerBasic> participants) {
    _participants.value = participants;
    _participants.isLoaded = true;
    notifyListeners();
  }

  @override
  void dispose() {
    print("TravelScopeStore was disposed: hashcode=${hashCode}");
    // TODO: implement dispose
    super.dispose();
  }
}
