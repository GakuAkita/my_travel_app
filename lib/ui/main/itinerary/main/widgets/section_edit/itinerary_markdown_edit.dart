import 'package:flutter/material.dart';
import 'package:my_travel_app/data/model/itinerary_section/itinerary_section.dart';

import '../../../../../../components/MultilineTextField.dart';
import '../../../../../../components/WhiteMarkdownBody.dart';

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

  /* 2回書くから関数化しているだけ */
  void _updateMarkdown() {
    widget.onChanged(_titleController.text, _contentController.text);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasContent = _contentController.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _titleController,
                onChanged: (newTitle) {
                  _updateMarkdown();
                },
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  hintText: "タイトル(空でも可)",
                  hintStyle: TextStyle(color: Colors.white38),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              tooltip: previewStatus ? "編集に戻る" : "プレビュー",
              isSelected: previewStatus,
              onPressed: hasContent ? () => setState(() => previewStatus = !previewStatus) : null,
              icon: const Icon(Icons.visibility_outlined),
              selectedIcon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (previewStatus && hasContent)
          Container(
            constraints: const BoxConstraints(minHeight: 80),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(4),
            ),
            child: WhiteMarkdownBody(data: _contentController.text, selectable: false),
          )
        else
          MultilineTextField(
            hintText: "本文(Markdown)",
            controller: _contentController,
            onChanged: (newContent) {
              _updateMarkdown();
              /* プレビューボタンの有効/無効を更新する */
              setState(() {});
            },
          ),
      ],
    );
  }
}
