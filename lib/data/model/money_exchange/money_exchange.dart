import 'package:freezed_annotation/freezed_annotation.dart';

part 'money_exchange.freezed.dart';
part 'money_exchange.g.dart';

@freezed
abstract class MoneyExchange with _$MoneyExchange {
  const factory MoneyExchange({
    required String sender,
    required String receiver,
    required double amount,
  }) = _MoneyExchange;

  factory MoneyExchange.fromJson(Map<String, dynamic> json) =>
      _$MoneyExchangeFromJson(json);
}
