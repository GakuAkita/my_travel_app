import 'package:my_travel_app/data/firebase_database_paths.dart';
import 'package:my_travel_app/data/repositories/users/users_repository.dart';
import 'package:my_travel_app/data/services/fake/fake_database.dart';

class UsersRepositoryFake implements UsersRepository {
  final FakeDatabase _database;

  UsersRepositoryFake({required FakeDatabase database}) : _database = database;

  @override
  Future<Map<String, dynamic>> getUsers() async => _database.getChildren(FirebaseDatabasePaths.users.path);
}
