import 'package:flutter/cupertino.dart';
import 'package:my_travel_app/data/model/itinerary_section/itinerary_section.dart';
import 'package:provider/provider.dart';

import '../../view_models/itinerary_viewmodel.dart';

class ItineraryMarkdownEdit extends StatefulWidget {
  final String section_id;

  const ItineraryMarkdownEdit({required this.section_id, super.key});

  @override
  State<ItineraryMarkdownEdit> createState() => _ItineraryMarkdownEditState();
}

class _ItineraryMarkdownEditState extends State<ItineraryMarkdownEdit> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final viewModel = context.read<ItineraryViewModel>();
    final section = viewModel.getSectionById(widget.section_id) as MarkdownSection;

    _titleController.text = section.title;
    _contentController.text = section.content;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: []);
  }
}
