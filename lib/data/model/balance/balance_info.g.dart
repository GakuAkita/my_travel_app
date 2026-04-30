// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BalanceInfo _$BalanceInfoFromJson(Map<String, dynamic> json) => _BalanceInfo(
  uid: json['uid'] as String,
  netTotal: (json['netTotal'] as num).toDouble(),
  reimbursedSum: (json['reimbursedSum'] as num).toDouble(),
  paidSum: (json['paidSum'] as num).toDouble(),
);

Map<String, dynamic> _$BalanceInfoToJson(_BalanceInfo instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'netTotal': instance.netTotal,
      'reimbursedSum': instance.reimbursedSum,
      'paidSum': instance.paidSum,
    };
