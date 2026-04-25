import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/data/model/itinerary_section/itinerary_section.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';
import 'package:provider/provider.dart';

class ItinerarySectionEdit extends StatelessWidget {
  final int index;

  /* 内部で結局ViewModelを参照することになる */
  const ItinerarySectionEdit({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final section = context.read<ItineraryViewModel>().editingItinerarySections[index];
    switch (section) {
      case MarkdownSection():
        return Text("MarkdownSection");
      case TableSection():
        return Text("ItinerarySection");
    }
  }
}
