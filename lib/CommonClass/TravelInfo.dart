class TravelInfo {
  final String id;
  final String name;

  TravelInfo({required this.id, required this.name});
}

class GroupTravels {
  String groupId;
  List<TravelInfo> travels;

  GroupTravels({required this.groupId, required this.travels});
}
