import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/ui/core/ui/TopAppBar.dart';
import 'package:my_travel_app/ui/main/settings/travel_create/view_models/travel_create_viewmodel.dart';
import 'package:provider/provider.dart';

class TravelCreateScreen extends StatefulWidget {
  const TravelCreateScreen({super.key});

  @override
  State<TravelCreateScreen> createState() => _TravelCreateScreenState();
}

class _TravelCreateScreenState extends State<TravelCreateScreen> {
  final TextEditingController _travelNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TravelCreateViewModel>();
    return Scaffold(
      appBar: TopAppBar(
        title: "Create Travel",
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          if (viewModel.joinedGroupIds.hasData &&
              viewModel.joinedGroupIds.data!.isNotEmpty) ...[
            Text("グループ選択"),
            Row(
              children: [
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    items:
                        viewModel.joinedGroupIds.data!.map<DropdownMenuItem>((
                          id,
                        ) {
                          return DropdownMenuItem<String>(
                            value: id,
                            child: Text(id, maxLines: 1),
                          );
                        }).toList(),
                    value: viewModel.selectedGroupId,
                    onChanged: (selected) {
                      viewModel.selectGroup(selected);
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: TextField(controller: _travelNameController)),
                ],
              ),
            ),
            RoundedButton(
              title: "旅行作成",
              onPressed: () async {
                if (_travelNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("旅行名を入力してください")));
                }
                final travelName = _travelNameController.text;
                final ret = await viewModel.createTravel(
                  travelName: travelName,
                );
                if (ret.isSuccess) {
                  context.pop();
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${ret.error?.errorMessage}")),
                  );
                }
              },
            ),

            if (viewModel.userTravels.hasData &&
                viewModel.userTravels.data!.isNotEmpty) ...[
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      items:
                          viewModel.joinedGroupIds.data!
                              .map(
                                (id) => DropdownMenuItem(
                                  value: id,
                                  child: Text(id),
                                ),
                              )
                              .toList(),
                      onChanged: (selected) {},
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}
