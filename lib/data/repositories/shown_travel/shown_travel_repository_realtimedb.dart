import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/core/exceptions/app_exception.dart';
import 'package:my_travel_app/data/repositories/shown_travel/shown_travel_repository.dart';

import '../../model/travel/shown_travel_basic/shown_travel_basic.dart';

class ShownTravelRepositoryRealtimeDb implements ShownTravelRepository {
  final String _userId;
  final FirebaseDatabase _firebaseDatabase;

  ShownTravelRepositoryRealtimeDb({
    required FirebaseDatabase firebaseDatabase,
    required String userId,
  }) : _firebaseDatabase = firebaseDatabase,
       _userId = userId;

  /* uidに依存させる */
  @override
  Future<ResultInfo<ShownTravelBasic>> getShownTravel() async {
    // TODO: implement getShownTravel
    throw AppException("Not implemented getShownTravel");
  }

  @override
  Future<ResultInfo<void>> setShownTravel(ShownTravelBasic travel) async {
    // TODO: implement setShownTravel
    throw AppException("Not implemented setShownTravel");
  }
}
