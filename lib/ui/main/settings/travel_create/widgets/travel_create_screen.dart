import 'package:flutter/material.dart';
import 'package:my_travel_app/ui/core/ui/TopAppBar.dart';
import 'package:my_travel_app/ui/main/settings/travel_create/view_models/travel_create_viewmodel.dart';
import 'package:provider/provider.dart';

class TravelCreateScreen extends StatelessWidget {
  const TravelCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TravelCreateViewModel>();
    return Scaffold(
      appBar: TopAppBar(
        title: "Create Travel",
        automaticallyImplyLeading: true,
      ),
      body: Column(),
    );
  }
}
