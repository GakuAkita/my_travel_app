import 'package:flutter/cupertino.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
