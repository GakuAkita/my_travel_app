import 'package:my_travel_app/CommonClass/ResultInfo.dart';

import '../CommonClass/ErrorInfo.dart';
import '../CommonClass/ShownTravelBasic.dart';

ResultInfo checkIsShownTravelInput(ShownTravelBasic? shownTravel) {
  if (shownTravel == null) {
    return ResultInfo.failed(
      error: ErrorInfo(errorMessage: "ShownTravelBasic is null."),
    );
  }

  if (shownTravel.groupId == null) {
    return ResultInfo.failed(
      error: ErrorInfo(errorMessage: "GroupId is null."),
    );
  }

  if (shownTravel.travelId == null) {
    return ResultInfo.failed(
      error: ErrorInfo(errorMessage: "TravelId is null."),
    );
  }

  return ResultInfo.success();
}
