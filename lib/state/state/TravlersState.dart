import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/data/repositories/participants/travelers_repository.dart';

/**
 * 旅行の参加者や役割に紐づく
 * - 参加車
 * - 総監督
 * - プランナー
 * 肥大化してきたら分割する
 */
class TravelersState extends ChangeNotifier {
  Map<String, TravelerBasic>? _participants;

  final ParticipantsRepository _participantsRepository;

  TravelersState({required ParticipantsRepository participantsRepository})
    : _participantsRepository = participantsRepository {
    print("TravelersState was created");
  }

  @override
  void dispose() {
    print("TravelersState was disposed");
    // TODO: implement dispose
    super.dispose();
  }
}
