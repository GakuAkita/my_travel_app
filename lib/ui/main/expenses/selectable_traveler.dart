import '../../../data/model/traveler/traveler_basic.dart';

class SelectableTraveler {
  final TravelerBasic traveler;
  final bool isChecked;

  const SelectableTraveler({required this.traveler, required this.isChecked});

  SelectableTraveler copyWith({TravelerBasic? traveler, bool? isChecked}) {
    return SelectableTraveler(
      traveler: traveler ?? this.traveler,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
