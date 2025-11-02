import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:my_travel_app/Store/ItineraryStore.dart';
import 'package:provider/provider.dart';

import '../MultilineTextField.dart';
import '../SimpleSwitch.dart';

class ItineraryMarkdownSectionEdit extends StatefulWidget {
  final int index;
  final void Function(String sectionName, String content) onChanged;
  const ItineraryMarkdownSectionEdit({
    required this.index,
    required this.onChanged,
    super.key,
  });

  @override
  State<ItineraryMarkdownSectionEdit> createState() =>
      _ItineraryMarkdownSectionEditState();
}

class _ItineraryMarkdownSectionEditState
    extends State<ItineraryMarkdownSectionEdit> {
  bool previewStatus = false;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text:
          Provider.of<ItineraryStore>(
            context,
            listen: false,
          ).getData()[widget.index].title,
    );
    _contentController = TextEditingController(
      text:
          Provider.of<ItineraryStore>(
            context,
            listen: false,
          ).getData()[widget.index].content,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itinerarySections = Provider.of<ItineraryStore>(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _titleController,
                  onChanged: (newTitle) {
                    itinerarySections.updateSectionTitle(
                      widget.index,
                      newTitle,
                    );
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
                    Text("Preview"),
                    SimpleSwitch(
                      width: 60,
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
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: Markdown(
                data:
                    _contentController.text.isNotEmpty
                        ? _contentController.text
                        : "contentがempty",
              ),
            )
          else
            MultilineTextField(
              hintText: "Markdown",
              controller: _contentController,
              onChanged: (newContent) {
                itinerarySections.updateSectionContent(
                  widget.index,
                  newContent,
                );
              },
            ),
        ],
      ),
    );
  }
}
