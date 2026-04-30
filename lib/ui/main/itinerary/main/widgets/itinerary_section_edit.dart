import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:my_travel_app/data/model/itinerary_section/itinerary_section.dart';
import 'package:my_travel_app/ui/main/itinerary/main/view_models/itinerary_viewmodel.dart';
import 'package:my_travel_app/ui/main/itinerary/main/widgets/section_edit/itinerary_markdown_edit.dart';
import 'package:my_travel_app/ui/main/itinerary/main/widgets/section_edit/itinerary_table_edit_button.dart';
import 'package:provider/provider.dart';

import '../../../../../routing/routes.dart';

class ItinerarySectionEdit extends StatelessWidget {
  final String id;

  /* 内部で結局ViewModelを参照することになる */
  const ItinerarySectionEdit({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final section = context.watch<ItineraryViewModel>().getSectionById(id);
    switch (section) {
      case MarkdownSection():
        return ItineraryMarkdownEdit(section_id: id);
      case TableSection():
        return ItineraryTableEditButton(
          onPressed: () {
            /* idを渡してTableEditScreenを立ち上が得る */
            context.push(Routes.itinerary_table_edit, extra: id);
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
