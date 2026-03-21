import 'package:my_travel_app/data/model/traveler/traveler_basic.dart';

class SelectedUser {
  final TravelerBasic traveler;
  final bool isChecked;

  SelectedUser({required this.traveler, required this.isChecked});

  SelectedUser copyWith({TravelerBasic? traveler, bool? isChecked}) {
    return SelectedUser(
      traveler: traveler ?? this.traveler,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
