import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';
import 'package:my_travel_app/ui/main/itinerary/main/widgets/itinerary_section_display.dart';
import 'package:provider/provider.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ItineraryViewModel>();
    return LoadingOverlay(
      isLoading: viewModel.isItineraryLoading,
      child: SingleChildScrollView(
        child:
            viewModel.travel == null
                ? Text("旅行が選択されていません。設定画面より表示する旅行を選択してください")
                : viewModel.itinerarySections.isEmpty
                ? Text("しおりが作られていません")
                : Column(
                  children:
                      viewModel.itinerarySections
                          .map(
                            (sec) => ItinerarySectionDisplay(itiSection: sec),
                          )
                          .toList(),
                ),
      ),
    );
  }
}
