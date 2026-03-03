import 'package:flutter/cupertino.dart';

class ItineraryStore extends ChangeNotifier {
  ItineraryStore() {
    print("ItineraryStore was created. hashCode=${hashCode}");
  }

  @override
  void dispose() {
    print("ItineraryStore was disposed. hashCode=${hashCode}");
    // TODO: implement dispose
    super.dispose();
  }
}
