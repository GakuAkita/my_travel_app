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
    return Scaffold(
      appBar: TopAppBar(title: "旅行選択", automaticallyImplyLeading: true),
      body: LoadingOverlay(
        isLoading: false,
        child: Column(children: [Text("作成中")]),
      ),
    );
  }
}
