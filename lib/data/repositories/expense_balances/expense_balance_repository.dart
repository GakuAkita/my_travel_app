import '../../model/balance/balance_info.dart';

abstract class ExpenseBalanceRepository {
  Future<Map<String, BalanceInfo>> getExpenseBalances({
    required String groupId,
    required String travelId,
  });
}
