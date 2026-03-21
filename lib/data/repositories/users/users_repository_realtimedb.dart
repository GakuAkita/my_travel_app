import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/users/users_repository.dart';
import 'package:my_travel_app/data/services/firebase_database_service.dart';

class UsersRepositoryRealtimeDb implements UsersRepository {
  final FirebaseDatabase _database;

  UsersRepositoryRealtimeDb(FirebaseDatabase firebaseDatabase)
    : _database = firebaseDatabase;

  FirebaseDatabaseService _service() {
    return FirebaseDatabaseService(
      database: _database,
      path: FirebaseDatabasePaths.users.path,
      fromJson: (m) => m,
      toJson: (m) => m,
    );
  }

  @override
  Future<Map<String, dynamic>> getUsers() async {
    final service = _service();
    final data = await service.getAll();
    return data;
  }
}
