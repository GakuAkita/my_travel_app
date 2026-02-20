import 'package:my_travel_app/data/model/travel/shown_travel_basic/shown_travel_basic.dart';
import 'package:my_travel_app/data/repositories/shown_travel/shown_travel_repository.dart';
import 'package:my_travel_app/state/session/shown_travel_session.dart';

class SwitchTravelUseCase {
  final ShownTravelRepository _travelRepository;
  final ShownTravelSession _travelSession;

  SwitchTravelUseCase({
    required ShownTravelRepository travelRepository,
    required ShownTravelSession travelSession,
  }) : _travelRepository = travelRepository,
       _travelSession = travelSession {
    print("SwitchTravelUseCase was created");
  }

  Future<void> execute(ShownTravelBasic? newTravel) async {
    /**
     *  sessionでnotifyListenersをするので
     *  sessionを監視しているViewModelは各々が動き出す
     *  */
    _travelSession.setShownTravel(newTravel);

    if (newTravel == null) {
    } else {
      await _travelRepository.setShownTravel(newTravel);
    }
  }
}
