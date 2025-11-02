import 'package:firebase_database/firebase_database.dart';
import 'package:my_travel_app/CommonClass/ErrorInfo.dart';
import 'package:my_travel_app/CommonClass/ResultInfo.dart';
import 'package:my_travel_app/Services/FirebaseDatabaseService.dart';
import 'package:my_travel_app/config/app_config.dart';

import '../constants.dart';

class UserService {
  Future<ResultInfo> createUserData(
    String userId,
    String email, {
    String role = UserRole.normal,
  }) async {
    String dev_message = "";

    try {
      DatabaseReference? ref = FirebaseDatabaseService.currentUserRef;
      if (ref == null) {
        throw Exception("current User Ref is null");
      }
      //emailを追加
      dev_message = "Unable to Add Email";
      await ref.update({"email": email});

      //roleを追加（local.propertiesから管理者メールアドレスを読み込む）
      if (AppConfig.isAdminEmail(email)) {
        role = UserRole.admin;
      }
      dev_message = "Unable to Add Role";
      await ref.update({"role": role});

      print("User data created successfully");
      return ResultInfo.success();
    } catch (e) {
      print("Error creating user data: $e");
      return ResultInfo.failed(
        error: ErrorInfo(errorMessage: e.toString() + "::" + dev_message),
      );
    }
  }
}
