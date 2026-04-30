import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/ui/main/settings/travel_select/view_models/travle_select_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../../constants.dart';
import '../../../../core/ui/top_app_bar.dart';

class TravelSelectScreen extends StatelessWidget {
  final String? userRole;

  const TravelSelectScreen({this.userRole, super.key});

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
                onChanged: (value) async {
                  if (value != null) {
                    viewModel.setSelectTravelId(value);
                    viewModel.setTravelers();
                  }
                },
                child: Column(
                  children: [
                    if (userTravels != null)
                      Column(
                        children: [
                          SelectTravelWidget(userTravels: userTravels),
                          RoundedButton(
                            title: "表示旅行選択",
                            onPressed: () {
                              final ret = viewModel.switchToSelectedTravel();
                              if (ret.isSuccess) {
                                context.pop();
                              } else {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text("${ret.error?.errorMessage}")));
                              }
                            },
                          ),
                        ],
                      )
                    else
                      /* まだユーザーの旅行が取得されていない */
                      Text("not loaded yet"),
                  ],
                ),
              ),
              if (userRole == UserRole.admin) ...[
                Row(children: [Text("参加者選択")]),
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final core = viewModel.selectableParticipants[index].traveler.core;
                        return CheckboxListTile(
                          value: viewModel.selectableParticipants[index].isChecked,
                          onChanged: (val) {
                            viewModel.switchChecked(index);
                          },
                          title: Text(core.email, maxLines: 1),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                      itemCount: viewModel.selectableParticipants.length,
                    ),
                    RoundedButton(
                      title: "参加者更新",
                      onPressed: () async {
                        final ret = await viewModel.setParticipants();
                        if (ret.isSuccess) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("更新しました")));
                          context.pop();
                        } else {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("${ret.error?.errorMessage}")));
                        }
                      },
                    ),
                  ],
                ),
              ],
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
        ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:
                userTravels.entries.map((groupEntry) {
                  final groupId = groupEntry.key;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text("${groupId}", maxLines: 1),
                      ...groupEntry.value.entries.map((travelEntry) {
                        final travelId = travelEntry.key;
                        final travelName = travelEntry.value;
                        return RadioListTile(value: travelId, title: Text(travelName));
                      }),
                    ],
                  );
                }).toList(),
          ),
        )
        : /* 取れたけどまだ旅行が作られていない */ Padding(padding: const EdgeInsets.all(8.0), child: Text("旅行が作成されていません。"));
  }
}
