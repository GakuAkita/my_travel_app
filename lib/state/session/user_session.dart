import 'package:flutter/foundation.dart';

class UserSession extends ChangeNotifier {
  @override
  void dispose() {
    print("UserSession was disposed");
    // TODO: implement dispose
    super.dispose();
  }
}
