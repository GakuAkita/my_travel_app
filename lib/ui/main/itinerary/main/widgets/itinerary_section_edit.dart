import 'package:flutter/material.dart';
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
        final color = Theme.of(context).colorScheme.onSurfaceVariant;
        return SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.space_bar, size: 18, color: color),
              const SizedBox(width: 8),
              Text("空白スペース", style: TextStyle(color: color)),
            ],
          ),
        );
    }
    return Text("Unknown section type");
  }
}
