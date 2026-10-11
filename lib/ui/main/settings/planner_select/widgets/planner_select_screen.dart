import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/core/ui/bottom_action_bar.dart';
import 'package:my_travel_app/ui/core/ui/section_header.dart';
import 'package:my_travel_app/ui/main/settings/planner_select/view_models/planner_select_viewmodel.dart';

class PlannerSelectScreen extends StatefulWidget {
  final PlannerSelectViewModel viewModel;

  const PlannerSelectScreen({super.key, required this.viewModel});

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
      widget.viewModel.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final selectables = viewModel.selectablePlanners.entries.toList();
        final checkedCount = selectables.where((s) => s.value.isChecked).length;
        return Scaffold(
          appBar: TopAppBar(title: "プランナー選択", automaticallyImplyLeading: true),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              SectionHeader(
                icon: Icons.manage_accounts_outlined,
                title: "プランナー",
                trailing: selectables.isEmpty ? null : "$checkedCount / ${selectables.length}人",
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                child: Text(
                  "プランナーは表示中の旅行のしおりを編集できます。",
                  style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                ),
              ),
              Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: selectables.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text("メンバーを読み込み中…", style: TextStyle(color: colorScheme.onSurfaceVariant)),
                      )
                    : Column(
                        children: [
                          for (final selectable in selectables)
                            CheckboxListTile(
                              value: selectable.value.isChecked,
                              title: Text(
                                selectable.value.traveler.displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (val) {
                                if (val != null) {
                                  viewModel.onSelectChanged(selectable.key, val);
                                }
                              },
                            ),
                        ],
                      ),
              ),
            ],
          ),
          bottomNavigationBar: BottomActionBar(
            label: "プランナー保存",
            onPressed: selectables.isEmpty
                ? null
                : () async {
                    final ret = await viewModel.savePlanners();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).clearSnackBars();
                    if (ret.isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("プランナーを設定しました")));
                      context.pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${ret.error?.errorMessage}")));
                    }
                  },
          ),
        );
      },
    );
  }
}
