import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/constants.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../../components/BasicText.dart';
import '../../../../../components/ValidatedSwitch.dart';
import 'itinerary_section_display.dart';

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

    final viewModel = context.read<ItineraryViewModel>();
    /* Adminなら常に編集モードを表示 */
    if (!viewModel.roleState.hasData || viewModel.roleState.hasError) {
      viewModel.fetchUserRole();
    } else {
      /* 再取得する必要はない */
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ItineraryViewModel>();
    return LoadingOverlay(
      isLoading: viewModel.isItineraryLoading,
      child: Column(
        children: [
          viewModel.isItineraryLoading
              ? Center(child: Text("Loading..."))
              : viewModel.travel == null
              ? Center(child: BasicText(text: "Settingsから表示旅行を設定してください"))
              : Expanded(
                /* 表示用 */
                child: RefreshIndicator(
                  onRefresh: () async {},
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10,
                      ),
                      child: Column(
                        children: [
                          if (viewModel.userRole == UserRole.admin)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BasicText(text: "プランナーモード"),
                                  SizedBox(width: 10),
                                  ValidatedSwitch(
                                    initialStatus: false,
                                    onWillChange: (val) async {
                                      return false;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          viewModel.itinerarySections.isEmpty
                              ? Center(child: BasicText(text: "しおりが作られていません"))
                              : Column(
                                children:
                                    viewModel.itinerarySections
                                        .map(
                                          (sec) => ItinerarySectionDisplay(
                                            itiSection: sec,
                                          ),
                                        )
                                        .toList(),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
