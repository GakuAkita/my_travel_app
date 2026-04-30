// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseInfo _$ExpenseInfoFromJson(Map<String, dynamic> json) => _ExpenseInfo(
  id: json['id'] as String?,
  payer: TravelerCore.fromJson(json['payer'] as Map<String, dynamic>),
  reimbursedBy: (json['reimbursedBy'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, TravelerCore.fromJson(e as Map<String, dynamic>)),
  ),
  expenseItem: json['expenseItem'] as String,
  expense: _expenseFromJson(json['expense']),
  createdAt: _createdAtFromJson(json['createdAt']),
);

Map<String, dynamic> _$ExpenseInfoToJson(
  _ExpenseInfo instance,
) => <String, dynamic>{
  'id': instance.id,
  'payer': instance.payer.toJson(),
  'reimbursedBy': instance.reimbursedBy.map((k, e) => MapEntry(k, e.toJson())),
  'expenseItem': instance.expenseItem,
  'expense': _expenseToJson(instance.expense),
  'createdAt': _createdAtToJson(instance.createdAt),
};
