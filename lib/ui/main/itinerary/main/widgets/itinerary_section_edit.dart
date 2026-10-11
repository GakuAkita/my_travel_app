import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/data/model/itinerary_section/itinerary_section.dart';
import 'package:my_travel_app/ui/main/itinerary/main/widgets/section_edit/itinerary_markdown_edit.dart';
import 'package:my_travel_app/ui/main/itinerary/main/widgets/section_edit/itinerary_table_edit_button.dart';

import '../../../../../routing/routes.dart';

class ItinerarySectionEdit extends StatelessWidget {
  final ItinerarySection section;

  /* Markdownが編集されたときに呼ばれる */
  final void Function(String title, String content) onMarkdownChanged;

  const ItinerarySectionEdit({super.key, required this.section, required this.onMarkdownChanged});

  @override
  Widget build(BuildContext context) {
    final section = this.section;
    switch (section) {
      case MarkdownSection():
        return ItineraryMarkdownEdit(section: section, onChanged: onMarkdownChanged);
      case TableSection():
        return ItineraryTableEditButton(
          onPressed: () {
            /* idを渡してTableEditScreenを立ち上が得る */
            context.push(Routes.itinerary_table_edit, extra: section.id);
          },
        );
      case SpaceSection():
        return Container(
          height: 40, // 高さを指定（中央寄せしやすく）
          alignment: Alignment.center, // ← これで中央寄せ
          child: Text("空白スペース"),
        );
    }
    return Text("Unknown section type");
  }
}
