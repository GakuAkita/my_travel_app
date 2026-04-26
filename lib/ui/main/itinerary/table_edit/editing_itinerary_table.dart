import 'package:my_travel_app/data/model/itinerary_table/itinerary_table.dart';

class EditingItineraryTable {
  List<String> header;
  List<List<String>> tableCells;
  List<int> flexes;

  EditingItineraryTable({required this.header, required this.tableCells, required this.flexes});
}

extension EditingItineraryTableExt on EditingItineraryTable {
  ItineraryTable toModel() {
    return ItineraryTable(header: header, tableCells: tableCells, flexes: flexes);
  }
}
