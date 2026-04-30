// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estimated_expense_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EstimatedExpenseInfo _$EstimatedExpenseInfoFromJson(
  Map<String, dynamic> json,
) => _EstimatedExpenseInfo(
  id: json['id'] as String,
  expenseItem: json['expenseItem'] as String,
  amount: (json['amount'] as num).toDouble(),
  reimbursedByCnt: (json['reimbursedByCnt'] as num).toInt(),
);

Map<String, dynamic> _$EstimatedExpenseInfoToJson(
  _EstimatedExpenseInfo instance,
) => <String, dynamic>{
  'id': instance.id,
  'expenseItem': instance.expenseItem,
  'amount': instance.amount,
  'reimbursedByCnt': instance.reimbursedByCnt,
};
