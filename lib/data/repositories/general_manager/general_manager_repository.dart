import 'package:my_travel_app/CommonClass/ResultInfo.dart';

abstract class GeneralManagerRepository {
  Future<ResultInfo<String>> getGeneralManager(String groupId, String travelId);

  Future<ResultInfo<String>> setGeneralManager(
    String groupId,
    String travelId,
    String uid,
  );

  Future<ResultInfo<void>> deleteGeneralManager(
    String groupId,
    String travelId,
  );
}
