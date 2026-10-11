import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:my_travel_app/data/model/itinerary_section/itinerary_section.dart';

import '../../../../../../components/MultilineTextField.dart';
import '../../../../../../components/SimpleSwitch.dart';

class ItineraryMarkdownEdit extends StatefulWidget {
  final MarkdownSection section;
  final void Function(String title, String content) onChanged;

  const ItineraryMarkdownEdit({required this.section, required this.onChanged, super.key});

  @override
  State<ItineraryMarkdownEdit> createState() => _ItineraryMarkdownEditState();
}

class _ItineraryMarkdownEditState extends State<ItineraryMarkdownEdit> {
  bool previewStatus = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final section = widget.section;

    _titleController.text = section.title;
    _contentController.text = section.content;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _updateMarkdown() {
      widget.onChanged(_titleController.text, _contentController.text);
    }
    /* 2回書くから関数化しているだけ */

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _titleController,
                  onChanged: (newTitle) {
                    _updateMarkdown();
                  },
                  decoration: InputDecoration(
                    hintText: "タイトル(空でも可)",
                    hintStyle: TextStyle(color: Colors.white38),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text("Preview", overflow: TextOverflow.ellipsis)),
                    SimpleSwitch(
                      width: 50,
                      height: 30,
                      isEnabled: _contentController.text.isNotEmpty,
                      onChanged: (status) {
                        setState(() {
                          previewStatus = status;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          if (previewStatus && _contentController.text.isNotEmpty)
            Container(
              height: 500,
              decoration: BoxDecoration(border: Border.all(color: Colors.white)),
              child: Markdown(
                data: _contentController.text.isNotEmpty ? _contentController.text : "contentがempty",
              ),
            )
          else
            MultilineTextField(
              hintText: "Markdown",
              controller: _contentController,
              onChanged: (newContent) {
                _updateMarkdown();
              },
            ),
        ],
      ),
    );
  }
}
