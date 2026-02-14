import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';

abstract class ShownTravelRepository {
  Future<ResultInfo<ShownTravelBasic>> getShownTravel();

  Future<ResultInfo<ShownTravelBasic>> setShownTravel(ShownTravelBasic travel);
}
