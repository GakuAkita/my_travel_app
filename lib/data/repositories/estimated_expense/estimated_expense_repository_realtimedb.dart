import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/estimated_expense/estimated_expense_repository.dart';

import '../../model/estimated_expense/estimated_expense_info.dart';
import '../../services/firebase_database_service.dart';

class EstimatedExpenseRepositoryRealtimeDb implements EstimatedExpenseRepository {
  final FirebaseDatabase _database;

  EstimatedExpenseRepositoryRealtimeDb({required FirebaseDatabase database}) : _database = database;

  FirebaseDatabaseService<EstimatedExpenseInfo> _service(String groupId, String travelId) {
    return FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.group(groupId).travels.travel(travelId).expenses.estimatedData.toString(),
      fromJson: EstimatedExpenseInfo.fromJson,
      toJson: (e) => e.toJson(),
    );
  }

  @override
  Future<List<EstimatedExpenseInfo>> getEstimatedExpenses({
    required String groupId,
    required String travelId,
  }) async {
    final service = _service(groupId, travelId);
    return service.getList();
  }

  @override
  Future<void> saveEstimatedExpenses({
    required String groupId,
    required String travelId,
    required List<EstimatedExpenseInfo> expenses,
  }) async {
    final service = _service(groupId, travelId);
    await service.setList(expenses);
  }
}
