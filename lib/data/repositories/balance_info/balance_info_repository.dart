import 'package:my_travel_app/data/model/balance/balance_info.dart';

abstract class BalanceInfoRepository {
  Future<Map<String, BalanceInfo>> getBalanceInfo({
    required String groupId,
    required String travelId,
  });
}
