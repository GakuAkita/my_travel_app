import 'package:flutter/widgets.dart';

import '../../../../data/repositories/auth/auth_repository.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  String _email = "";

  ResetPasswordViewModel({required this.authRepository});

  void updateEmail(String email) {
    _email = email;
    /* 外に使えるわけではないので、notifyListeners()は使わない */
  }
}
