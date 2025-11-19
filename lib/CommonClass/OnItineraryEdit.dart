import 'TravelerBasic.dart';

class OnItineraryEdit extends TravelerBasic {
  final bool on_edit;

  OnItineraryEdit({String? uid, String? email, required this.on_edit})
    : super(uid: uid ?? "", email: email ?? "");

  @override
  OnItineraryEdit copyWith({
    String? uid,
    String? email,
    String? profile_name,
    bool? on_edit,
  }) {
    return OnItineraryEdit(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      on_edit: on_edit ?? this.on_edit,
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'on_edit': on_edit};
  }

  static OnItineraryEdit convFromMap(Map<dynamic, dynamic> map) {
    final Map<String, dynamic> rawMap = map.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    final uid = rawMap["uid"] as String?;
    final email = rawMap["email"] as String?;
    final on_edit = rawMap["on_edit"] as bool? ?? false;

    return OnItineraryEdit(uid: uid, email: email, on_edit: on_edit);
  }
}

const String OtherUserEditing = "other-user-edit";
