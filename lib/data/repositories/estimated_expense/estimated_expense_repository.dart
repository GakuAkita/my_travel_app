import 'package:my_travel_app/data/model/estimated_expense/estimated_expense_info.dart';

abstract class EstimatedExpenseRepository {
  Future<List<EstimatedExpenseInfo>> getEstimatedExpenses({
    required String groupId,
    required String travelId,
  });

  Future<void> saveEstimatedExpenses({
    required String groupId,
    required String travelId,
    required List<EstimatedExpenseInfo> expenses,
  });
}
