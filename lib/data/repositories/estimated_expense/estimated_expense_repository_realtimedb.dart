import 'package:my_travel_app/data/repositories/estimated_expense/estimated_expense_repository.dart';

import '../../model/estimated_expense/estimated_expense_info.dart';

class EstimatedExpenseRepositoryRealtimeDb implements EstimatedExpenseRepository {
  @override
  Future<List<EstimatedExpenseInfo>> getEstimatedExpenses({
    required String groupId,
    required String travelId,
  }) async {
    return [];
  }

  @override
  Future<void> saveEstimatedExpenses({
    required String groupId,
    required String travelId,
    required List<EstimatedExpenseInfo> expenses,
  }) async {
    // TODO: implement saveEstimatedExpenses
    return;
  }
}
