import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';

class PlannerSelectScreen extends StatefulWidget {
  const PlannerSelectScreen({super.key});

  @override
  State<PlannerSelectScreen> createState() => _PlannerSelectScreenState();
}

class _PlannerSelectScreenState extends State<PlannerSelectScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /* 初期化 */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true),
      body: LoadingOverlay(
        isLoading: false,
        child: SafeArea(child: Column(children: [Center()])),
      ),
    );
  }
}
