import 'package:flutter/widgets.dart';

import '../../../../data/repositories/auth/auth_repository.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  ResetPasswordViewModel({required this.authRepository});
}
