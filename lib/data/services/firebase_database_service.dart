import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/data/model/identifiable.dart';
import 'package:my_travel_app/data/model/timestamped.dart';

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

  /// データ取得 (単一ノード)
  Future<T?> get() async {
    final snapshot = await _database.ref(path).get();
    if (!snapshot.exists) return null;

    final map = Map<String, dynamic>.from(snapshot.value as Map);
    return fromJson(map);
  }

  // 一気に取る場合はこっち(ただし、同じ構造になっている前提)
  Future<Map<String, T>> getAll() async {
    final snapshot = await _database.ref(path).get();
    if (!snapshot.exists) return {};

    final raw = Map<String, dynamic>.from(snapshot.value as Map);

    return raw.map((key, value) {
      final item = fromJson(Map<String, dynamic>.from(value as Map));
      return MapEntry(key, item);
    });
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
    final key = ref.key!;

    // copyWithが実装されていること前提！！
    // freezedなら問題ない
    final newItem = (item as dynamic).copyWith(id: key) as T;

    Map<String, dynamic> newItemMap = toJson(newItem);
    if (newItem is Creatable) {
      newItemMap['createdAt'] = ServerValue.timestamp;
    }

    if (newItem is Updatable) {
      newItemMap['updatedAt'] = ServerValue.timestamp;
    }

    await ref.set(newItemMap);

    return newItem;
  }

  // Future<T> updateAuto(T item) async{
  //
  // }
}
