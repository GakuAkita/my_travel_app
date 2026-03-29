import '../../../CommonClass/BalanceInfo.dart';

abstract class ExpenseBalanceRepository {
  Future<Map<String, BalancesInfo>> getExpenseBalances({
    required String groupId,
    required String travelId,
  });
}
