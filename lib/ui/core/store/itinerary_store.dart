import 'package:flutter/cupertino.dart';

class ItineraryStore extends ChangeNotifier {
  @override
  void dispose() {
    print("ItineraryStore was disposed. hashCode=${hashCode}");
    // TODO: implement dispose
    super.dispose();
  }
}
