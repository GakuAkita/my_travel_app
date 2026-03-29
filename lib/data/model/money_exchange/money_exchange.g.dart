// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_exchange.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MoneyExchange _$MoneyExchangeFromJson(Map<String, dynamic> json) =>
    _MoneyExchange(
      sender: json['sender'] as String,
      receiver: json['receiver'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$MoneyExchangeToJson(_MoneyExchange instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'receiver': instance.receiver,
      'amount': instance.amount,
    };
