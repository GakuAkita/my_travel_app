import 'package:my_travel_app/data/model/money_exchange/money_exchange.dart';

abstract class ExpenseResultRepository {
  Future<String> getExpenseResultLastUpdated({
    required String groupId,
    required String travelId,
  });

  Future<List<MoneyExchange>> getExchangeData({
    required String groupId,
    required String travelId,
  });
}
