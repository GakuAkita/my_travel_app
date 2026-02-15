import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/participants/participants_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';

/**
 * 旅行の参加者や役割に紐づく
 * - 参加車
 * - 総監督
 * - プランナー
 * 肥大化してきたら分割する
 */
class TravelersState extends ChangeNotifier {
  ShownTravelBasic? _travel;
  Map<String, TravelerBasic>? _participants;
  String? _generalManager;
  Map<String, TravelerBasic>? _planners;

  Map<String, TravelerBasic>? get participants => _participants;

  String? get generalManager => _generalManager;

  Map<String, TravelerBasic>? get planners => _planners;

  final ShownTravelSession _travelSession;
  final ParticipantsRepository _participantsRepository;

  TravelersState({
    required ShownTravelSession travelSession,
    required ParticipantsRepository participantsRepository,
  }) : _travelSession = travelSession,
       _participantsRepository = participantsRepository {
    print("TravelersState was created");

    _travelSession.addListener(_onTravelChanged);
  }

  void _onTravelChanged() async {
    print("TravelersState detected travel changed.");

    if (_travel == _travelSession.currentTravel) return;

    /* ここでロードする */
  }

  @override
  void dispose() {
    print("TravelersState was disposed");
    // TODO: implement dispose
    super.dispose();
  }
}
