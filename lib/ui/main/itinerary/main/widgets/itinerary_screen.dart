import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';

import '../../../../../components/ValidatedSwitch.dart';
import '../../../../../data/model/itinerary_section/itinerary_section.dart';
import '../../../../core/ui/empty_state.dart';
import 'itinerary_section_display.dart';
import 'itinerary_section_edit.dart';

class ItineraryScreen extends StatefulWidget {
  final ItineraryViewModel viewModel;

  const ItineraryScreen({super.key, required this.viewModel});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  ItineraryViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();

    /* Adminなら常に編集モードを表示 */
    if (!viewModel.roleState.hasData || viewModel.roleState.hasError) {
      viewModel.fetchUserRole();
    } else {
      /* 再取得する必要はない */
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return LoadingOverlay(isLoading: viewModel.isItineraryLoading, child: _buildBody());
      },
    );
  }

  Widget _buildBody() {
    if (viewModel.isItineraryLoading) {
      return const SizedBox.expand();
    }
    if (viewModel.travel == null) {
      return const EmptyState(
        icon: Icons.luggage_outlined,
        message: "表示する旅行が選択されていません",
        hint: "Settingsから表示旅行を設定してください",
      );
    }
    return Column(
      children: [
        if (viewModel.canEdit())
          _PlannerModeBar(
            editMode: viewModel.editMode,
            switchEnabled: !viewModel.isEditLoading /* 複数連続タップ禁止 */,
            onWillChange: _onPlannerModeWillChange,
          ),
        Expanded(child: viewModel.editMode ? _buildEditingList() : _buildDisplayList()),
      ],
    );
  }

  /// プランナーモード(編集モードと同義)を切り替える前の確認。戻り値がスイッチの新しい状態になる
  Future<bool> _onPlannerModeWillChange(bool newVal) async {
    if (newVal) {
      /* offからonにするとき */
      final ret = await viewModel.switchEditModePreCheckWithNotify();
      if (ret.isSuccess) {
        viewModel.setEditMode(newVal);
        viewModel.copySectionsToBuffer();
        return newVal;
      } else {
        print("${ret.error?.errorMessage}");
        viewModel.setEditMode(!newVal);
        _showSnackBar(ret.error?.errorMessage ?? "Unknown error");
        return !newVal; /* 変更せずの元の状態を保持 */
      }
    }

    /* 保存するか。nullは編集を続ける */
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("プランナーモードを終了"),
        content: const Text("編集内容を保存してから終了しますか？"),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text("編集を続ける")),
          TextButton(
            onPressed: () => context.pop(false),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text("保存せずに終了"),
          ),
          FilledButton(onPressed: () => context.pop(true), child: const Text("保存して終了")),
        ],
      ),
    );
    if (confirm == null) {
      print("switch EditMode Canceled");
      return !newVal;
    }

    if (confirm) {
      /* editingを転写し、データをリモートに上げる */
      final ret = await viewModel.saveItinerarySections();
      if (ret.isSuccess) {
        /* watchでItineraryStoreで自動で更新される。 */
      } else {
        _showSnackBar(ret.error?.errorMessage ?? "Unknown error");
        return !newVal;
      }
    } else {
      /* 保存せずに閉じるので、editingの内容はそのままにして捨てる */
      print("Switch to editMode off without saving itinerary");
    }
    /* onEditを消しに行く */
    await viewModel.removeItineraryOnEdit(); /* エラーチェックはいいや */
    viewModel.setEditMode(newVal);
    return newVal;
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /* 表示用 */
  Widget _buildDisplayList() {
    final sections = viewModel.itinerarySections;
    return RefreshIndicator(
      onRefresh: () async {},
      child: sections.isEmpty
          ? CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    icon: Icons.menu_book_outlined,
                    message: "しおりがまだ作られていません",
                    hint: viewModel.canEdit() ? "プランナーモードをオンにして作成しましょう" : "プランナーが作成するまでお待ちください",
                  ),
                ),
              ],
            )
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [for (final sec in sections) ItinerarySectionDisplay(itiSection: sec)],
            ),
    );
  }

  Widget _buildEditingList() {
    final sections = viewModel.editingItinerarySections;
    final colorScheme = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: [
        const SliverPadding(padding: EdgeInsets.only(top: 4)),
        SliverReorderableList(
          itemCount: sections.length,
          onReorder: viewModel.reorderSection,
          itemBuilder: (context, index) {
            final section = sections[index];
            return Padding(
              key: ValueKey(section.id),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        final ret = viewModel.removeSection(section.id);
                        if (ret < 0) {
                          /* 削除に失敗。ほとんどないけどね。 */
                        }
                      },
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      borderRadius: BorderRadius.circular(12),
                      icon: Icons.delete_outline,
                      label: "削除",
                    ),
                  ],
                ),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Row(
                    children: [
                      if (sections.length >= 2)
                        ReorderableDragStartListener(
                          index: index,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(Icons.drag_indicator, color: colorScheme.onSurfaceVariant),
                          ),
                        )
                      else
                        const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                          child: ItinerarySectionEdit(
                            section: section,
                            onMarkdownChanged: (title, content) {
                              viewModel.updateItineraryMarkdownSection(
                                sectionId: section.id,
                                title: title,
                                content: content,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (sections.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                "セクションがありません。\n下のボタンから追加してください。",
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
            child: OutlinedButton.icon(
              onPressed: _addSection,
              icon: const Icon(Icons.add),
              label: const Text("セクションを追加"),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _addSection() async {
    final selectedSection = await showModalBottomSheet<ItinerarySection>(
      context: context,
      showDragHandle: true,
      builder: (context) => const _AddSectionSheet(),
    );
    if (selectedSection != null) {
      print("selectedSection = ${selectedSection.runtimeType}");
      viewModel.addSection(selectedSection);
    } else {
      print("add section canceled");
    }
  }
}

/// プランナーモードの状態と切り替えスイッチ
class _PlannerModeBar extends StatelessWidget {
  final bool editMode;
  final bool switchEnabled;
  final Future<bool> Function(bool newValue) onWillChange;

  const _PlannerModeBar({required this.editMode, required this.switchEnabled, required this.onWillChange});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: editMode ? colorScheme.primary.withValues(alpha: 0.12) : colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: editMode ? colorScheme.primary : colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(editMode ? Icons.edit_note : Icons.visibility_outlined, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("プランナーモード", style: TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  editMode ? "左スワイプで削除\nドラッグで並び替え" : "オンにするとしおりを編集できます",
                  style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ValidatedSwitch(initialStatus: editMode, isEnabled: switchEnabled, onWillChange: onWillChange),
        ],
      ),
    );
  }
}

class _AddSectionSheet extends StatelessWidget {
  const _AddSectionSheet();

  @override
  Widget build(BuildContext context) {
    Widget option(IconData icon, String title, String subtitle, ItinerarySection Function() create) {
      return ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () => context.pop(create()),
      );
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text("追加するセクション", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ),
          option(Icons.text_fields, "テキスト(Markdown)", "見出しと本文をMarkdownで書く", ItinerarySection.emptyMarkdown),
          option(Icons.table_chart_outlined, "テーブル", "行と列で予定や持ち物を整理する", ItinerarySection.emptyTable),
          option(Icons.space_bar, "空白", "セクションの間に余白を入れる", ItinerarySection.emptySpace),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
