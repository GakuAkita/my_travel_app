import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/repositories/shown_travel/shown_travel_repository.dart';

import '../../model/travel/shown_travel_basic/shown_travel_basic.dart';

class ShownTravelRepositoryRealtimeDb implements ShownTravelRepository {
  final String _userId;

  ShownTravelRepositoryRealtimeDb({required String userId}) : _userId = userId;

  /* uidに依存させる */
  @override
  Future<ResultInfo<ShownTravelBasic>> getShownTravel() async {
    // TODO: implement getShownTravel
    return ResultInfo.success();
  }

  @override
  Future<ResultInfo<void>> setShownTravel(ShownTravelBasic travel) async {
    // TODO: implement setShownTravel
    return ResultInfo.success();
  }
}
