import 'package:my_travel_app/CommonClass/ResultInfo.dart';

import '../../CommonClass/ErrorInfo.dart';
import '../../data/model/travel/shown_travel_basic/shown_travel_basic.dart';

/**
 * 命名が難しいけど、
 * こっちはnullでないことが確定していて、
 * groupIdとtravelIdがちゃんと入っているかチェックする
 */
ResultInfo checkIsShownTravelValid(ShownTravelBasic shownTravel) {
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
