import 'package:freezed_annotation/freezed_annotation.dart';

part 'itinerary_table.freezed.dart';
part 'itinerary_table.g.dart';

@freezed
abstract class ItineraryTable with _$ItineraryTable {
  const factory ItineraryTable({
    @Default(["時間", "場所", "メモ"]) List<String> header,
    @Default([]) List<List<String>> tableCells,
    @Default([2, 3, 3]) List<int> flexes,
  }) = _ItineraryTable;

  factory ItineraryTable.fromJson(Map<String, dynamic> json) =>
      _$ItineraryTableFromJson(json);
}
