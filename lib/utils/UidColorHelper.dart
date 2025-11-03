import 'package:flutter/material.dart';

/// UIDに基づいて色を割り当てるためのユーティリティクラス
/// 同じUIDには常に同じ色が割り当てられるようにする
class UidColorHelper {
  // 基本となる色のリスト（Material Designの色相から）
  static const List<Color> colorPalette = [
    Color.fromARGB(255, 232, 245, 233), // Light Green
    Color.fromARGB(255, 227, 242, 253), // Light Blue
    Color.fromARGB(255, 255, 243, 224), // Light Orange
    Color.fromARGB(255, 245, 224, 233), // Light Pink
    Color.fromARGB(255, 237, 231, 246), // Light Purple
    Color.fromARGB(255, 255, 236, 179), // Light Amber
    Color.fromARGB(255, 224, 247, 250), // Light Cyan
    Color.fromARGB(255, 255, 228, 225), // Light Red
  ];

  static const List<Color> textColorPalette = [
    Color.fromARGB(255, 27, 94, 32), // Dark Green
    Color.fromARGB(255, 13, 71, 161), // Dark Blue
    Color.fromARGB(255, 230, 81, 0), // Dark Orange
    Color.fromARGB(255, 136, 14, 79), // Dark Pink
    Color.fromARGB(255, 74, 20, 140), // Dark Purple
    Color.fromARGB(255, 255, 143, 0), // Dark Amber
    Color.fromARGB(255, 0, 96, 100), // Dark Cyan
    Color.fromARGB(255, 183, 28, 28), // Dark Red
  ];

  /// members全体をソートして、各UIDのインデックス（順序）を取得
  /// 同じUIDには常に同じ順序が割り当てられる
  static Map<String, int> getUidColorIndexMap(
    Map<String, dynamic> participants,
  ) {
    // members全体のUIDをハッシュ値でソート
    final List<String> sortedUids = participants.keys.toList();
    sortedUids.sort((a, b) => a.hashCode.compareTo(b.hashCode));

    // UIDとそのインデックス（順序）のマップを作成
    final Map<String, int> uidColorIndexMap = {};
    for (int i = 0; i < sortedUids.length; i++) {
      uidColorIndexMap[sortedUids[i]] = i;
    }

    return uidColorIndexMap;
  }

  /// UIDから背景色を取得
  static Color getColorForUid(String uid, Map<String, int> uidColorIndexMap) {
    int orderIndex = uidColorIndexMap[uid] ?? 0;
    return colorPalette[orderIndex % colorPalette.length];
  }

  /// UIDからテキスト色を取得
  static Color getTextColorForUid(
    String uid,
    Map<String, int> uidColorIndexMap,
  ) {
    int orderIndex = uidColorIndexMap[uid] ?? 0;
    return textColorPalette[orderIndex % textColorPalette.length];
  }
}
