import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_travel_app/data/model/itinerary_table/itinerary_table.dart';

part 'itinerary_section.freezed.dart';
part 'itinerary_section.g.dart';

@freezed
abstract class ItinerarySection with _$ItinerarySection {
  const factory ItinerarySection.markdown({
    required String title,
    required String content,
  }) = MarkdownSection;

  const factory ItinerarySection.table({required ItineraryTable tableData}) =
      TableSection;

  const factory ItinerarySection.space() = SpaceSection;

  /// !!!! 一度通常の書き方でitinerary_section.g.dartを生成してから、
  /// 変換用に書き換える。
  /// freezedはあくまで自動生成だから、ちゃんとフォーマットに従って書かれていないと生成してくれないっぽい。
  // factory ItinerarySection.fromJson(Map<String, dynamic> json) =>
  //     _$ItinerarySectionFromJson(json);
  factory ItinerarySection.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = Map<String, dynamic>.from(json);

    /* 旧キー "type" -> "runtimeType" */
    if (newJson.containsKey('type') && !newJson.containsKey('runtimeType')) {
      newJson['runtimeType'] = newJson['type'];
    }

    /* 旧値の変換 */
    /* default_tableをtableに変換 */
    switch (newJson['runtimeType']) {
      case "default_table":
        newJson['runtimeType'] = 'table';
        break;
      default:
        break;
    }

    return _$ItinerarySectionFromJson(newJson);
  }
}
