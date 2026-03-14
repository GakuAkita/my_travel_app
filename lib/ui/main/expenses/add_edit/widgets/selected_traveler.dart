import 'package:my_travel_app/data/model/traveler/traveler_core/traveler_core.dart';

class SelectedTraveler {
  final TravelerCore traveler;
  final bool isChecked;

  SelectedTraveler({required this.traveler, required this.isChecked});

  SelectedTraveler copyWith({TravelerCore? traveler, bool? isChecked}) {
    return SelectedTraveler(
      traveler: traveler ?? this.traveler,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
