import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/ui/main/settings/travel_select/view_models/travle_select_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../core/ui/TopAppBar.dart';

class TravelSelectScreen extends StatelessWidget {
  const TravelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TravelSelectViewModel>();
    final userTravels = viewModel.userTravels;

    return Scaffold(
      appBar: TopAppBar(title: "旅行選択", automaticallyImplyLeading: true),
      body: LoadingOverlay(
        isLoading: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              RadioGroup<String>(
                groupValue: viewModel.selectedTravelId,
                onChanged: (value) {
                  if (value != null) {
                    viewModel.setSelectTravelId(value);
                  }
                },
                child: Column(
                  children: [
                    if (userTravels != null)
                      SelectTravelWidget(userTravels: userTravels)
                    else
                      /* まだユーザーの旅行が取得されていない */
                      Text("not loaded yet"),
                  ],
                ),
              ),
              if (userTravels != null)
                Row()
              else
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Text("データを読み込み中...")),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectTravelWidget extends StatelessWidget {
  final Map<String, Map<String, String>> userTravels;

  const SelectTravelWidget({required this.userTravels, super.key});

  @override
  Widget build(BuildContext context) {
    return userTravels.isNotEmpty
        ? Column(
          children:
              userTravels.entries.map((groupEntry) {
                final groupId = groupEntry.key;
                return Column(
                  children: [
                    Text("${groupId}"),
                    ...groupEntry.value.entries.map((travelEntry) {
                      final travelId = travelEntry.key;
                      final travelName = travelEntry.value;
                      return Row(
                        children: [Radio(value: travelId), Text(travelName)],
                      );
                    }),
                  ],
                );
              }).toList(),
        )
        : /* 取れたけどまだ旅行が作られていない */ Row();
  }
}
