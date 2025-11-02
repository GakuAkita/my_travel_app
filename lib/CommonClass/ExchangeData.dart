import 'MoneyExchange.dart';

class ExchangeData {
  final String? lastUpdated;
  final List<MoneyExchange> result;

  ExchangeData({this.lastUpdated, required this.result});

  static ExchangeData convFromMap(Map<dynamic, dynamic> map) {
    final rawList = map["result"];
    final List<MoneyExchange> resultList = [];
    for (var item in rawList) {
      if (item != null) {
        resultList.add(MoneyExchange.convFromMap(item));
      }
    }
    return ExchangeData(lastUpdated: map["lastUpdated"], result: resultList);
  }
}
