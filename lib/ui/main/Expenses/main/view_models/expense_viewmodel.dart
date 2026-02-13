import 'package:flutter/cupertino.dart';

class ExpenseViewModel extends ChangeNotifier {
  @override
  void dispose() {
    print("ExpenseViewModel was disposed");
    // TODO: implement dispose
    super.dispose();
  }
}
