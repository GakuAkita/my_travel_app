import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_travel_app/data/model/identifiable.dart';
import 'package:my_travel_app/data/model/timestamped.dart';

import '../../../ui/main/expenses/expense_detail.dart';
import '../traveler/traveler_core/traveler_core.dart';

part 'expense_info.freezed.dart';
part 'expense_info.g.dart';

@freezed
abstract class ExpenseInfo
    with _$ExpenseInfo
    implements Identifiable, Creatable {
  @JsonSerializable(explicitToJson: true)
  const factory ExpenseInfo({
    required String? id,
    required TravelerCore payer,
    required Map<String, TravelerCore> reimbursedBy,
    required String expenseItem,
    required int expense,
    /* nameを変える場合はFirebaseDatabaseServiceも変えないとだめ */
    @JsonKey(
      name: 'createdAt',
      fromJson: _createdAtFromJson,
      toJson: _createdAtToJson,
    )
    int? createdAt, //一度決めたら変えない
  }) = _ExpenseInfo;

  factory ExpenseInfo.fromJson(Map<String, dynamic> json) =>
      _$ExpenseInfoFromJson(json);
}

/**
 * 以前はcreatedAtをISOのdatetimeで保存していたが、それをUNIXミリ秒のint?二変更。
 * 後方互換戦を持たせるために、converterを定義
 */
int? _createdAtFromJson(dynamic value) {
  if (value == null) return null;

  // すでにミリ秒(int)
  if (value is int) return value;

  // 万一 double で来た場合
  if (value is num) return value.toInt();

  // 旧ISO文字列
  if (value is String) {
    final date = DateTime.tryParse(value);
    if (date != null) {
      return date.millisecondsSinceEpoch; // ← ミリ秒
    }
  }

  return null;
}

int? _createdAtToJson(int? value) => value;

extension ExpenseInfoExt on ExpenseInfo {
  ExpenseDetail toDetail(String userId) {
    final members = reimbursedBy.keys.toSet();
    int len = members.length;
    if (len == 0) {
      /* まあ基本的に0になることはないが */
      print(
        "This should not happen!! No Reimbursed by.　expenseId=$id expenseItem=$expenseItem",
      );
      len = -1; /* 負の値にして気づかせる */
    }
    final perPerson = expense / len;

    return ExpenseDetail(
      expenseId: id ?? '',
      expenseItem: expenseItem,
      paidAmount: payer.uid == userId ? expense.toDouble() : 0,
      owedAmount: members.contains(userId) ? perPerson : 0,
    );
  }
}

extension ExpenseInfoMapExt on Map<String, ExpenseInfo> {
  Map<String, List<ExpenseDetail>> toAllDetails() {
    final Map<String, List<ExpenseDetail>> result = {};

    for (final expense in values) {
      final members = expense.reimbursedBy.keys.toSet();

      if (members.isEmpty) {
        print(
          "This should not happen!! No Reimbursed by. expenseId=${expense.id} expenseItem=${expense.expenseItem}",
        );
        continue;
      }

      final perPerson = expense.expense / members.length;

      for (final uid in members) {
        result.putIfAbsent(uid, () => []);
        result[uid]!.add(
          ExpenseDetail(
            expenseId: expense.id ?? "",
            expenseItem: expense.expenseItem,
            paidAmount:
                expense.payer.uid == uid ? expense.expense.toDouble() : 0,
            owedAmount: perPerson,
          ),
        );
      }
    }

    return result;
  }
}
