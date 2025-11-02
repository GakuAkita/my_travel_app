import 'package:my_travel_app/constants.dart';

import 'ItineraryDefaultTable.dart';

class ItinerarySection {
  String type;
  String title;

  //text用
  String? content;

  //table用
  ItineraryDefaultTable? tableData;

  ItinerarySection({
    required this.type,
    this.title = "",
    this.content,
    this.tableData,
  });

  ItinerarySection copyWith({
    String? type,
    String? title,
    String? content,
    ItineraryDefaultTable? tableData,
  }) {
    return ItinerarySection(
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      tableData: tableData ?? this.tableData,
    );
  }

  Map<String, dynamic> convToMap() {
    return {
      "type": type,
      "title": title,
      "content": content,
      "tableData": tableData?.convToMap(),
    };
  }

  static ItinerarySection convToItinerarySection(Map<String, dynamic> rawMap) {
    /* typeによって変換方法が違う */
    if (rawMap["type"] == ItinerarySectionType.markdown) {
      return ItinerarySection(
        type: rawMap["type"],
        title: rawMap["title"],
        content: rawMap["content"],
        tableData: null,
      );
    } else if (rawMap["type"] == ItinerarySectionType.defaultTable) {
      final tblDataMap = rawMap["tableData"].map(
        (key, value) => MapEntry(key.toString(), value),
      );
      return ItinerarySection(
        type: rawMap["type"],
        title: rawMap["title"],
        content: null,
        tableData: ItineraryDefaultTable.convToTable(tblDataMap),
      );
    } else {
      return ItinerarySection(type: rawMap["type"]);
    }
  }
}
