import 'package:my_travel_app/data/model/money_exchange/money_exchange.dart';

abstract class MoneyExchangeRepository {
  Future<String?> getMoneyExchangeLastUpdated({
    required String groupId,
    required String travelId,
  });

  Future<List<MoneyExchange>> getMoneyExchangeData({
    required String groupId,
    required String travelId,
  });
}
