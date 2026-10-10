import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/estimated_expense/estimated_expense_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

import '../../model/estimated_expense/estimated_expense_info.dart';

class EstimatedExpenseRepositoryFake implements EstimatedExpenseRepository {
  final FakeDatabase _database;

  EstimatedExpenseRepositoryFake({required FakeDatabase database}) : _database = database;

  String _path(String groupId, String travelId) =>
      FirebaseDatabasePaths.group(groupId).travels.travel(travelId).expenses.estimatedData;

  @override
  Future<List<EstimatedExpenseInfo>> getEstimatedExpenses({required String groupId, required String travelId}) async =>
      _database.getList(_path(groupId, travelId)).map(EstimatedExpenseInfo.fromJson).toList();

  @override
  Future<void> saveEstimatedExpenses({
    required String groupId,
    required String travelId,
    required List<EstimatedExpenseInfo> expenses,
  }) async => _database.set(_path(groupId, travelId), expenses.isEmpty ? null : expenses.map((e) => e.toJson()).toList());
}
