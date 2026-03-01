import 'package:flutter/foundation.dart';

class ExpenseStore extends ChangeNotifier {
  @override
  void dispose() {
    print("ExpenseStore was disposed. hashCode=${hashCode}");
    // TODO: implement dispose
    super.dispose();
  }
}
