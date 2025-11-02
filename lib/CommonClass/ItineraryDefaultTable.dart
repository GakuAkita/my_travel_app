class ItineraryDefaultTable {
  final List<int> flexes;
  final List<String> header;
  final List<List<String>> tableCells;

  ItineraryDefaultTable({
    List<String>? header,
    List<List<String>>? tableCells,
    List<int>? flexes,
  }) : header = header ?? ["時間", "場所", "メモ"],
       tableCells = tableCells ?? [],
       flexes = flexes ?? [2, 3, 3];

  Map<String, dynamic> convToMap() {
    return {"flexes": flexes, "header": header, "tableCells": tableCells};
  }

  /* Map<String,dynamic>を渡すのか、Map<Object?,Object?>のまま渡すのか統一感がないな */
  static ItineraryDefaultTable convToTable(Map<Object?, Object?> rawMap) {
    final Map<String, dynamic> map = rawMap.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    final header = List<String>.from(map["header"] ?? []);
    final flexes = List<int>.from(map["flexes"] ?? []);

    final tableCellsRaw = map["tableCells"];
    final tableCells =
        (tableCellsRaw is List)
            ? tableCellsRaw
                .map(
                  (row) =>
                      List<String>.from((row as List).map((e) => e.toString())),
                )
                .toList()
            : <List<String>>[];

    return ItineraryDefaultTable(
      header: header,
      flexes: flexes,
      tableCells: tableCells,
    );
  }
}
