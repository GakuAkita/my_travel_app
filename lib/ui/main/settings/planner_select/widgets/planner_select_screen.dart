import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/settings/planner_select/view_models/planner_select_viewmodel.dart';
import 'package:provider/provider.dart';

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

    /* 描画されてから初期化 */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlannerSelectViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PlannerSelectViewModel>();
    return Scaffold(
      appBar: TopAppBar(automaticallyImplyLeading: true),
      body: LoadingOverlay(
        isLoading: false,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                ...viewModel.selectablePlanners.entries.map(
                  (selectable) => CheckboxListTile(
                    value: selectable.value.isChecked,
                    title: Text(selectable.value.traveler.displayName),
                    onChanged: (val) {
                      if (val != null) {
                        viewModel.onSelectChanged(selectable.key, val);
                      }
                    },
                  ),
                ),
                RoundedButton(
                  title: "プランナー保存",
                  onPressed: () async {
                    final ret = await viewModel.savePlanners();
                    if (ret.isSuccess) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("プランナーを設定しました")));
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
          ),
        ),
      ),
    );
  }
}
