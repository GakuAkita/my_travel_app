import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_travel_app/data/model/identifiable.dart';
import 'package:my_travel_app/data/model/timestamped.dart';

import '../traveler/traveler_basic/traveler_basic.dart';

part 'expense_info.freezed.dart';
part 'expense_info.g.dart';

@freezed
abstract class ExpenseInfo
    with _$ExpenseInfo
    implements Identifiable, Creatable {
  const factory ExpenseInfo({
    required String? id,
    required TravelerBasic payer,
    required Map<String, Map<String, String>> reimbursedBy,
    required String expenseItem,
    required int expense,
    /* nameを変える場合はFirebaseDatabaseServiceも変えないとだめ */
    @JsonKey(name: 'createdAt') int? createdAt, //一度決めたら変えない
  }) = _ExpenseInfo;

  factory ExpenseInfo.fromJson(Map<String, dynamic> json) =>
      _$ExpenseInfoFromJson(json);
}
