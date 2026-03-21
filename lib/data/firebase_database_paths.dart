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

  static GroupPath group(String groupId) => GroupPath(groups.child(groupId));

  static UserPath user(String userId) => UserPath(users.child(userId));

  static GroupKey groupKey(String groupId) =>
      GroupKey(groupKeys.child(groupId));
}

class GroupKey extends PathNode {
  GroupKey(String parentPath) : super(parentPath);

  String travel(String travelId) => child(travelId);
}

/// ===============================
/// Users
/// ===============================
class UserPath extends PathNode {
  UserPath(String userId) : super(userId);

  SettingsPath get settings => SettingsPath(child("settings"));

  String get role => child("role");
}

/* last_loginとかは設定ではないから、将来的には移動したほうがいいかも */
class SettingsPath extends PathNode {
  SettingsPath(String parentPath) : super(parentPath);

  String get shown_travel => child("shown_travel");

  String get joined_groups => child("joined_groups");

  String get last_login_at => child("last_login_at");

  String get profile_name => child("profile_name");

  String joined_group(String groupId) => "$joined_groups/$groupId";
}

/// ===============================
/// Groups
/// ===============================
class GroupPath extends PathNode {
  GroupPath(String path) : super(path);

  TravelsPath get travels => TravelsPath(path);

  String get members => child("members");

  String get creator => child("creator");
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

  ExpensesPath get expenses => ExpensesPath(path);

  String get name => child("name");

  String get createdAt => child("createdAt");

  String get itinerary => child("itinerary");

  String get travelers => child("travelers");
}

class ExpensesPath extends PathNode {
  ExpensesPath(String parentPath) : super("$parentPath/expenses");

  final String _exchangesStr = "exchanges";
  final String _estimatedStr = "estimated";
  final String _dataStr = "data";

  String get data => child(_dataStr);

  String singleData(String expenseId) => child("$_dataStr/$expenseId");

  String get balances => child("balances");

  String get exchanges => child("$_exchangesStr/result");
}

class ItineraryPath extends PathNode {
  ItineraryPath(String parentPath) : super("$parentPath/itinerary");

  String get sections => child("sections");

  String get onEdit => child("on_edit");
}
