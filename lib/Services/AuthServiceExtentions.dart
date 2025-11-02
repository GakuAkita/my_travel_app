import 'package:my_travel_app/Services/AuthService.dart';

import 'FirebaseDatabaseService.dart';

extension UserRoleExtention on AuthService {
  Future<String?> fetchUserRole() async {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return null;

    try {
      final snapshot =
          await FirebaseDatabaseService.usersRef.child(uid).child("role").get();

      if (snapshot.exists) {
        return snapshot.value as String;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching role: $e");
      return null;
    }
  }
}
