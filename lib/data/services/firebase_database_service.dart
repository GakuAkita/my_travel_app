import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/model/identifiable.dart';

class FirebaseDatabaseService<T> {
  final FirebaseDatabase _database;
  final String path;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  FirebaseDatabaseService({
    required FirebaseDatabase database,
    required this.path,
    required this.fromJson,
    required this.toJson,
  }) : _database = database;

  /// データをセット（上書き）
  Future<void> set(T item) async {
    await _database.ref(path).set(toJson(item));
  }

  /// データを更新（部分更新）
  Future<void> update(T item) async {
    await _database.ref(path).update(toJson(item));
  }

  /// データ取得
  Future<T?> get() async {
    final snapshot = await _database.ref(path).get();
    if (!snapshot.exists) return null;

    final map = Map<String, dynamic>.from(snapshot.value as Map);
    return fromJson(map);
  }

  /// データをlisten
  Stream<T?> stream() {
    return _database.ref(path).onValue.map((event) {
      final value = event.snapshot.value;
      if (value == null) return null;
      final map = Map<String, dynamic>.from(value as Map);
      return fromJson(map);
    });
  }
}

extension FirebaseDatabaseServiceExtension<T extends Identifiable>
    on FirebaseDatabaseService<T> {
  Future<T> addAuto(T item) async {
    final ref = _database.ref(path).push();
    final key = ref.key;

    // copyWithが実装されていること前提！！
    final newItem = (item as dynamic).copyWith(id: key) as T;

    await ref.set(toJson(newItem));

    return newItem;
  }
}
