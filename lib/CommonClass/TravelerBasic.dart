import 'TravelerInfo.dart';

class TravelerBasic {
  final String uid;
  final String email;
  final String? profile_name;

  TravelerBasic({required this.uid, required this.email, this.profile_name});

  TravelerBasic copyWith({String? uid, String? email, String? profile_name}) {
    return TravelerBasic(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      profile_name: profile_name ?? this.profile_name,
    );
  }

  static TravelerBasic convFromMap(Map map) {
    return TravelerBasic(uid: map["uid"], email: map["email"]);
  }

  static String getProfileNameFromUid(
    String uid,
    Map<String, TravelerBasic> members,
  ) {
    if (members[uid] == null) {
      return "*"; /*uidが見つからなかった時*/
    }
    String nameShown = members[uid]!.profile_name ?? members[uid]!.email;

    return nameShown;
  }
}

extension TravelerBasicExtensions on TravelerBasic {
  TravelerInfo toTravelerInfo({bool isChecked = true}) {
    return TravelerInfo(
      uid: uid,
      email: email,
      profile_name: profile_name,
      isChecked: isChecked,
    );
  }
}
