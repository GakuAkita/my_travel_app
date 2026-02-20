import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';

abstract class ShownTravelRepository {
  Future<ShownTravelBasic?> getShownTravel();

  Future<void> setShownTravel(ShownTravelBasic travel);

  Future<void> deleteShownTravel();
}
