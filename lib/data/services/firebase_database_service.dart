import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/core/utils/normalize.dart';
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

  //Mapじゃなくて単一の値を入れたいときだけ
  Future<void> setValue<R>(R value) async {
    await _database.ref(path).set(value);
  }

  /// データをセット（上書き
  /// ノードごと上書きするので注意!!）
  Future<void> set(T item) async {
    await _database.ref(path).set(toJson(item));
  }

  /* toJsonを適用していき、一気にMapをセットする */
  Future<void> setAll(Map<String, T> items) async {
    final map = items.map((key, value) => MapEntry(key, toJson(value)));
    await _database.ref(path).set(map);
  }

  /// データを更新（部分更新）
  Future<void> update(T item) async {
    await _database.ref(path).update(toJson(item));
  }

  // ノードの一個の値
  Future<R?> getValue<R>() async {
    final snapshot = await _database.ref(path).get();
    if (!snapshot.exists) return null;
    return snapshot.value as R;
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
    if (!snapshot.exists || snapshot.value == null) return {};

    final normalized =
        normalizeMapStructure(snapshot.value) as Map<String, dynamic>;

    return normalized.map((key, value) {
      final item = fromJson(value as Map<String, dynamic>);
      return MapEntry(key, item);
    });
  }

  Future<List<T>> getList() async {
    final snapshot = await _database.ref(path).get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final value = snapshot.value;

    // Listの場合
    if (value is List) {
      /* これ順番守ってくれるかな、、 */
      return value
          .where((e) => e != null)
          .map((e) => fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    // Mapの場合（Firebaseあるある）
    if (value is Map) {
      final normalized = normalizeMapStructure(value) as Map<String, dynamic>;

      return normalized.values.map((e) {
        return fromJson(Map<String, dynamic>.from(e));
      }).toList();
    }

    // 想定外
    return [];
  }

  Future<void> delete() async {
    await _database.ref(path).remove();
  }

  /// データをlisten
  Stream<Map<String, T>> streamAll() {
    return _database.ref(path).onValue.map((event) {
      print("$path listened");
      final value = event.snapshot.value;
      if (value == null) return {};

      final normalized = normalizeMapStructure(value) as Map<String, dynamic>;

      return normalized.map((key, value) {
        final item = fromJson(value as Map<String, dynamic>);
        return MapEntry(key, item);
      });
    });
  }

  Stream<List<T>> streamList() {
    return _database.ref(path).onValue.map((event) {
      final value = event.snapshot.value;
      if (value == null) return [];

      if (value is List) {
        return value.where((e) => e != null).map((e) {
          /* Mapの中にListが入るこんでいたりするとキャストできないので、convertMapを挟む */
          return fromJson(Map<String, dynamic>.from(normalizeMapStructure(e)));
        }).toList();
      }

      // Map化されて変える場合
      if (value is Map) {
        final normalized = normalizeMapStructure(value) as Map<String, dynamic>;
        return normalized.values.map((e) {
          return fromJson(Map<String, dynamic>.from(e));
        }).toList();
      }

      return [];
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
}
