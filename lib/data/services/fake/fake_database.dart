import 'dart:async';
import 'dart:convert';

/// Realtime Databaseをメモリ上で再現したもの(Fakeモード用)
/// 本物と同じくJSONツリーで持つので、FirebaseDatabasePathsとモデルのfromJson/toJsonをそのまま使える。
class FakeDatabase {
  final Map<String, dynamic> _root = {};
  final StreamController<String> _changes = StreamController<String>.broadcast();
  int _pushCounter = 0;

  /// ノードを取得(コピーを返す)。存在しなければnull
  dynamic get(String path) {
    dynamic node = _root;
    for (final segment in _segments(path)) {
      if (node is Map) {
        node = node[segment];
      } else if (node is List) {
        final index = int.tryParse(segment);
        node = (index != null && index < node.length) ? node[index] : null;
      } else {
        return null;
      }
      if (node == null) return null;
    }
    return _deepCopy(node);
  }

  /// 子ノードをMapで取得(FirebaseDatabaseService.getAll相当)
  Map<String, Map<String, dynamic>> getChildren(String path) {
    final value = get(path);
    if (value is! Map) return {};
    return value.map((key, child) => MapEntry(key as String, Map<String, dynamic>.from(child as Map)));
  }

  /// 子ノードをListで取得(FirebaseDatabaseService.getList相当)
  List<Map<String, dynamic>> getList(String path) {
    final value = get(path);
    if (value is List) {
      return value.where((e) => e != null).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    if (value is Map) {
      return value.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
  }

  /// ノードごと上書き。nullなら削除
  void set(String path, dynamic value) {
    final segments = _segments(path);
    if (value == null) {
      _removeAt(segments);
    } else {
      Map<String, dynamic> node = _root;
      for (final segment in segments.take(segments.length - 1)) {
        final child = node[segment];
        if (child is Map<String, dynamic>) {
          node = child;
        } else {
          final newChild = <String, dynamic>{};
          node[segment] = newChild;
          node = newChild;
        }
      }
      node[segments.last] = _deepCopy(value);
    }
    _changes.add(path);
  }

  /// 部分更新
  void update(String path, Map<String, dynamic> values) {
    values.forEach((key, value) => set("$path/$key", value));
  }

  void remove(String path) => set(path, null);

  /// push()のキー生成。本物と同じく時系列順にソートされる
  String pushKey() {
    final time = DateTime.now().millisecondsSinceEpoch;
    return "-fake$time${(_pushCounter++).toString().padLeft(4, '0')}";
  }

  /// pathの値を監視する。最初に現在の値を流し、その後pathに関係する変更があるたびに流す
  /// (async*だとcancel()が次のイベントまで終わらないので、StreamControllerで作る)
  Stream<T> watch<T>(String path, T Function(dynamic value) convert) {
    StreamSubscription<String>? changesSubscription;
    late final StreamController<T> controller;
    controller = StreamController<T>(
      onListen: () {
        controller.add(convert(get(path)));
        changesSubscription = _changes.stream
            .where((changedPath) => _overlaps(changedPath, path))
            .listen((_) => controller.add(convert(get(path))));
      },
      onCancel: () => changesSubscription?.cancel(),
    );
    return controller.stream;
  }

  void _removeAt(List<String> segments) {
    final parents = <Map<String, dynamic>>[];
    Map<String, dynamic> node = _root;
    for (final segment in segments.take(segments.length - 1)) {
      final child = node[segment];
      if (child is! Map<String, dynamic>) return;
      parents.add(node);
      node = child;
    }
    node.remove(segments.last);

    /* Firebaseは空のノードを持たないので、空になった親も消す */
    for (var i = parents.length - 1; i >= 0; i--) {
      final child = parents[i][segments[i]];
      if (child is Map && child.isEmpty) {
        parents[i].remove(segments[i]);
      } else {
        break;
      }
    }
  }

  static List<String> _segments(String path) => path.split('/').where((s) => s.isNotEmpty).toList();

  static bool _overlaps(String a, String b) => a == b || a.startsWith("$b/") || b.startsWith("$a/");

  static dynamic _deepCopy(dynamic value) => jsonDecode(jsonEncode(value));
}
