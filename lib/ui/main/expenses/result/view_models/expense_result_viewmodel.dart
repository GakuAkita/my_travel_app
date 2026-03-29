import 'package:flutter/widgets.dart';

class ExpenseResultViewModel extends ChangeNotifier {
  ExpenseResultViewModel() {
    print("ExpenseResultViewModel Created. $hashCode");
  }

  @override
  void dispose() {
    print("dispose ExpenseResultViewModel $hashCode");
    // TODO: implement dispose
    super.dispose();
  }
}
