import 'package:my_travel_app/CommonClass/TravelerBasic.dart';

class ExpenseInfo {
  final String id;
  final TravelerBasic payer;
  final Map<String, Map<String, String>> reimbursedBy;

  /* Map<uid, Map<email,実際のemail>> */
  final String expenseItem;
  final int expense;
  final String createdAt;

  /* Stringで保存しておいて使うときだけDateTimeにする */

  ExpenseInfo({
    required this.id, //何も入っていなければnull
    required this.payer,
    required this.reimbursedBy,
    required this.expenseItem,
    required this.expense,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'payer': {'uid': payer.uid, 'email': payer.email},
      'reimbursedBy': reimbursedBy, // そのまま入れる
      'expenseItem': expenseItem,
      'expense': expense,
      'createdAt': createdAt,
    };
  }

  ExpenseInfo copyWith({
    String? id,
    TravelerBasic? payer,
    Map<String, Map<String, String>>? reimbursedBy,
    String? expenseItem,
    int? expense,
    String? createdAt,
  }) {
    return ExpenseInfo(
      id: id ?? this.id,
      payer: payer ?? this.payer,
      reimbursedBy: reimbursedBy ?? this.reimbursedBy,
      expenseItem: expenseItem ?? this.expenseItem,
      expense: expense ?? this.expense,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /**
   *RealtimeDatabaseから取ったやつをこれで変換
   */
  static ExpenseInfo convFromMapToExpenseInfo(Map<dynamic, dynamic> map) {
    final payerMap = Map<String, dynamic>.from(map['payer'] as Map);
    TravelerBasic payer = TravelerBasic(
      uid: payerMap["uid"],
      email: payerMap["email"],
    );
    /* payerMapにはprofile_nameがないので、ここで保存しておく */
    final reimbursedByRaw = Map<String, dynamic>.from(
      map['reimbursedBy'] as Map,
    );
    final reimbursedBy = <String, Map<String, String>>{};
    reimbursedByRaw.forEach((key, value) {
      reimbursedBy[key] = Map<String, String>.from(value as Map);
    });

    final bufExpense = ExpenseInfo(
      id: map['id'] as String,
      payer: payer,
      reimbursedBy: reimbursedBy,
      expenseItem: map['expenseItem'] as String,
      expense: map['expense'] as int,
      createdAt: map['createdAt'] as String,
    );

    return bufExpense;
  }
}

/**
 * 個人の支出詳細を表すクラス
 * 実際にかかった金額
 */
class ExpensePersonalDetail {
  final String expenseId;
  final String expenseItem;
  final double amountPerPerson; //立て替えてもらった金額

  ExpensePersonalDetail({
    required this.expenseId,
    required this.expenseItem,
    required this.amountPerPerson,
  });

  // 個人負担の合計を計算
  static double sumPersonalDetailList(List<ExpensePersonalDetail> list) {
    return list.fold(0.0, (prev, element) => prev + element.amountPerPerson);
  }
}

/**
 * 自分が支払ったものだけ抽出
 */
class ExpensePaidDetail {
  final String expenseId;
  final String expenseItem;
  final double paidAmount;

  ExpensePaidDetail({
    required this.expenseId,
    required this.expenseItem,
    required this.paidAmount,
  });

  static double sumPaidDetailList(List<ExpensePaidDetail> list) {
    return list.fold(0.0, (prev, element) => prev + element.paidAmount);
  }
}

class EstimatedExpenseInfo {
  final String id;
  final String expenseItem;
  final double amount;
  final int reimbursedByCnt;

  EstimatedExpenseInfo({
    required this.id,
    required this.expenseItem,
    required this.amount,
    required this.reimbursedByCnt,
  });

  static EstimatedExpenseInfo fromExpenseInfo(ExpenseInfo info) {
    return EstimatedExpenseInfo(
      id: info.id,
      expenseItem: info.expenseItem,
      amount: info.expense.toDouble(),
      reimbursedByCnt: info.reimbursedBy.length,
    );
  }

  static convFromMap(Map<dynamic, dynamic> map) {
    return EstimatedExpenseInfo(
      id: map['id'] as String,
      expenseItem: map['expenseItem'] as String,
      amount: map['amount'] as double,
      reimbursedByCnt: map['reimbursedByCnt'] as int,
    );
  }
}
