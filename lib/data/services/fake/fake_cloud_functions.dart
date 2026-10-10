import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/model/balance/balance_info.dart';
import 'package:my_travel_app/data/model/expense/expense_info.dart';
import 'package:my_travel_app/data/model/money_exchange/money_exchange.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

/// functions/src/index.ts のCloud FunctionsをDartに移植したもの(Fakeモード用)
/// 本物を変更したらこっちも合わせること。
class FakeCloudFunctions {
  FakeCloudFunctions._();

  /// onExpenseDataChange: expenses/data が変わったらbalancesとexchangesを再計算する
  static void onExpenseDataChange(FakeDatabase db, String groupId, String travelId) {
    final expensesPath = FirebaseDatabasePaths.group(groupId).travels.travel(travelId).expenses;
    final exchangesPath = expensesPath.child("exchanges");

    final current = db.getChildren(expensesPath.data);
    if (current.isEmpty) {
      db.remove(expensesPath.balances);
      db.remove(exchangesPath);
      return;
    }

    final expenses = current.values.map(ExpenseInfo.fromJson).toList();
    final balances = _calcBalances(expenses);
    final exchanges = _calcMoneyExchange(balances);

    db.set(expensesPath.balances, balances.map((uid, balance) => MapEntry(uid, balance.toJson())));
    db.set(expensesPath.exchanges, exchanges.map((e) => e.toJson()).toList());
    db.set(expensesPath.lastUpdated, DateTime.now().toUtc().toIso8601String());
  }

  /// onUserCreate: ユーザー作成時に users/{uid} を作る
  static void onUserCreate(FakeDatabase db, String uid, String? email) {
    db.update(FirebaseDatabasePaths.user(uid).path, {
      "email": email ?? "null_address@gmail.com",
      "role": "normal",
    });
  }

  static Map<String, BalanceInfo> _calcBalances(List<ExpenseInfo> expenses) {
    final Map<String, BalanceInfo> balances = {};
    BalanceInfo empty(String uid) => BalanceInfo(uid: uid, netTotal: 0, paidSum: 0, reimbursedSum: 0);

    for (final expense in expenses) {
      final payerId = expense.payer.uid;
      final involvedUids = expense.reimbursedBy.keys;
      final shareAmount = expense.expense / involvedUids.length;

      for (final uid in involvedUids) {
        final b = balances[uid] ?? empty(uid);
        balances[uid] = b.copyWith(
          reimbursedSum: b.reimbursedSum + shareAmount,
          netTotal: b.netTotal - shareAmount,
        );
      }

      final payer = balances[payerId] ?? empty(payerId);
      balances[payerId] = payer.copyWith(
        paidSum: payer.paidSum + expense.expense,
        netTotal: payer.netTotal + expense.expense,
      );
    }
    return balances;
  }

  static List<MoneyExchange> _calcMoneyExchange(Map<String, BalanceInfo> balances) {
    final creditors = <({String id, double amount})>[];
    final debtors = <({String id, double amount})>[];

    for (final entry in balances.entries) {
      /* JSのMath.roundと同じ丸め方(.5は+方向) */
      final net = (entry.value.netTotal + 0.5).floorToDouble();
      if (net > 0) {
        creditors.add((id: entry.key, amount: net));
      } else if (net < 0) {
        debtors.add((id: entry.key, amount: -net));
      }
    }

    final exchanges = <MoneyExchange>[];
    while (creditors.isNotEmpty && debtors.isNotEmpty) {
      final creditor = creditors.first;
      final debtor = debtors.first;
      final amount = creditor.amount < debtor.amount ? creditor.amount : debtor.amount;

      exchanges.add(MoneyExchange(sender: debtor.id, receiver: creditor.id, amount: amount));

      creditors[0] = (id: creditor.id, amount: creditor.amount - amount);
      debtors[0] = (id: debtor.id, amount: debtor.amount - amount);
      if (creditors.first.amount == 0) creditors.removeAt(0);
      if (debtors.first.amount == 0) debtors.removeAt(0);
    }
    return exchanges;
  }
}
