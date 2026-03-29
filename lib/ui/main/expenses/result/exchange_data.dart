import '../../../../data/model/money_exchange/money_exchange.dart';

class ExchangeData {
  final String? lastUpdated;
  final List<MoneyExchange> result;

  ExchangeData({this.lastUpdated, required this.result});

  /* これ必要ないな、、 */
  static ExchangeData convFromMap(Map<dynamic, dynamic> map) {
    final rawList = map["result"];
    final List<MoneyExchange> resultList = [];
    for (var item in rawList) {
      if (item != null) {
        resultList.add(MoneyExchange.fromJson(item));
      }
    }
    return ExchangeData(lastUpdated: map["lastUpdated"], result: resultList);
  }
}
