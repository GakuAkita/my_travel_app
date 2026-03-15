import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';

class SelectedTraveler {
  final TravelerBasic traveler;
  final bool isChecked;

  SelectedTraveler({required this.traveler, required this.isChecked});

  SelectedTraveler copyWith({TravelerBasic? traveler, bool? isChecked}) {
    return SelectedTraveler(
      traveler: traveler ?? this.traveler,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
