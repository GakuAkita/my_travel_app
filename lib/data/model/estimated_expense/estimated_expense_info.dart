import 'package:freezed_annotation/freezed_annotation.dart';

part 'estimated_expense_info.freezed.dart';
part 'estimated_expense_info.g.dart';

@freezed
abstract class EstimatedExpenseInfo with _$EstimatedExpenseInfo {
  const factory EstimatedExpenseInfo({
    required String id,
    required String expenseItem,
    required double amount,
    required int reimbursedByCnt,
  }) = _EstimatedExpenseInfo;

  factory EstimatedExpenseInfo.fromJson(Map<String, dynamic> json) => _$EstimatedExpenseInfoFromJson(json);
}
