import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_travel_app/ui/main/itinerary/table_edit/editing_itinerary_table.dart';

part 'itinerary_table.freezed.dart';
part 'itinerary_table.g.dart';

@freezed
abstract class ItineraryTable with _$ItineraryTable {
  const factory ItineraryTable({
    @Default(["時間", "場所", "メモ"]) List<String> header,
    @Default([]) List<List<String>> tableCells,
    @Default([2, 3, 3]) List<int> flexes,
  }) = _ItineraryTable;

  factory ItineraryTable.fromJson(Map<String, dynamic> json) => _$ItineraryTableFromJson(json);
}

extension ItineraryTableExt on ItineraryTable {
  EditingItineraryTable toEditing() {
    return EditingItineraryTable(
      header: List.from(header),
      tableCells: tableCells.map((e) => List<String>.from(e)).toList(),
      flexes: List.from(flexes),
    );
  }
}
