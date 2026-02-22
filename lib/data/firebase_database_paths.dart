// class FirebaseDatabasePaths {
//   static String users() => "users";
//
//   static String groups() => "groups";
//
//   static String members(String groupId, String travelId) =>
//       "${travelers(groupId, travelId)}/members";
//
//   static String groupKeys() => "group_keys";
//
//   static String user(String userId) => "${users()}/$userId";
//
//   static String travels(String groupId) => "${groups()}/$groupId/travels";
//
//   static String travel(String groupId, String travelId) =>
//       "${travels(groupId)}/$travelId";
//
//   static String expenses(String groupId, String travelId) =>
//       "${travel(groupId, travelId)}/expenses";
//
//   static String itinerary(String groupId, String travelId) =>
//       "${travel(groupId, travelId)}/itinerary";
//
//   static String travelers(String groupId, String travelId) =>
//       "${travel(groupId, travelId)}/travelers";
// }

/// ===============================
/// Base
/// ===============================
class PathNode {
  final String path;

  const PathNode(this.path);

  String child(String segment) => "$path/$segment";

  @override
  String toString() => path;
}

/// ===============================
/// Root
/// ===============================
class FirebaseDatabasePaths {
  FirebaseDatabasePaths._();

  static const PathNode users = PathNode("users");
  static const PathNode groups = PathNode("groups");
  static const PathNode groupKeys = PathNode("group_keys");
}

/// ===============================
/// Users
/// ===============================
class UserPath extends PathNode {
  UserPath(String userId) : super(FirebaseDatabasePaths.users.child(userId));

  // 必要ならここに user 配下のノード追加
}

/// ===============================
/// Groups
/// ===============================
class GroupPath extends PathNode {
  GroupPath(String groupId)
    : super(FirebaseDatabasePaths.groups.child(groupId));

  TravelsPath get travels => TravelsPath(path);
}

/// ===============================
/// Travels
/// ===============================
class TravelsPath extends PathNode {
  TravelsPath(String parentPath) : super("$parentPath/travels");

  TravelPath travel(String travelId) => TravelPath(child(travelId));
}

/// ===============================
/// Travel
/// ===============================
class TravelPath extends PathNode {
  TravelPath(String path) : super(path);

  String get expenses => child("expenses");

  String get itinerary => child("itinerary");

  String get travelers => child("travelers");

  String get members => child("travelers/members");
}
