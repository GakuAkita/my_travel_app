import 'TravelerBasic.dart';

class TravelerInfo extends TravelerBasic {
  final bool isChecked;

  TravelerInfo({
    required String uid,
    required String email,
    String? profile_name,
    required this.isChecked,
  }) : super(uid: uid, email: email, profile_name: profile_name);

  @override
  TravelerInfo copyWith({
    String? uid,
    String? email,
    String? profile_name,
    bool? isChecked,
  }) {
    return TravelerInfo(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      profile_name: profile_name ?? this.profile_name,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
