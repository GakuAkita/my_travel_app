import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../../components/BasicText.dart';
import '../../../../../components/ValidatedSwitch.dart';
import '../../../../../constants.dart';
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
                child: Column(
                  children: [
                    if (viewModel.userRole == UserRole.admin)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BasicText(text: "プランナーモード"),
                            /* 編集モードと同義 */
                            SizedBox(width: 10),
                            ValidatedSwitch(
                              initialStatus: viewModel.editMode,
                              isEnabled: !viewModel.isEditLoading,
                              /* 複数連続タップ禁止 */
                              onWillChange: (newVal) async {
                                final ret = await viewModel
                                    .switchEditModePreCheckWithNotify(newVal);
                                if (ret.isSuccess) {
                                  viewModel.setEditMode(newVal);
                                  return newVal;
                                } else {
                                  print("${ret.error?.errorMessage}");
                                  viewModel.setEditMode(!newVal);
                                  ScaffoldMessenger.of(
                                    context,
                                  ).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        ret.error?.errorMessage ??
                                            "Unknown error",
                                      ),
                                    ),
                                  );
                                  return !newVal; /* 変更せずの元の状態を保持 */
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child:
                          viewModel.editMode
                              ? ListView(
                                children: [
                                  Center(
                                    child: Text("プランナーモードをOFFにしたときに保存されます"),
                                  ),
                                ],
                              )
                              : RefreshIndicator(
                                /* 表示用 */
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
                                        if (viewModel.itinerarySections.isEmpty)
                                          Center(
                                            child: BasicText(
                                              text: "しおりが作られていません",
                                            ),
                                          )
                                        else
                                          ...viewModel.itinerarySections.map(
                                            (sec) => ItinerarySectionDisplay(
                                              itiSection: sec,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
