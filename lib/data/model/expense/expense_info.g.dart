// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseInfo _$ExpenseInfoFromJson(Map<String, dynamic> json) => _ExpenseInfo(
  id: json['id'] as String?,
  payer: TravelerBasic.fromJson(json['payer'] as Map<String, dynamic>),
  reimbursedBy: (json['reimbursedBy'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, Map<String, String>.from(e as Map)),
  ),
  expenseItem: json['expenseItem'] as String,
  expense: (json['expense'] as num).toInt(),
  createdAt: (json['createdAt'] as num?)?.toInt(),
  updatedAt: (json['updatedAt'] as num?)?.toInt(),
);

Map<String, dynamic> _$ExpenseInfoToJson(_ExpenseInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payer': instance.payer,
      'reimbursedBy': instance.reimbursedBy,
      'expenseItem': instance.expenseItem,
      'expense': instance.expense,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
