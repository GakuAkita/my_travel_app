import 'package:flutter/material.dart';

class MultilineTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String initialText;
  final String hintText;
  final int? maxLines;
  final int? minLines;
  final InputBorder border;
  final FocusNode? focusNode;
  final void Function(String content) onChanged;

  const MultilineTextField({
    Key? key,
    this.controller,
    this.initialText = '',
    this.hintText = '',
    this.maxLines,
    this.minLines,
    this.focusNode,
    this.border = const OutlineInputBorder(),
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveController =
        controller ?? TextEditingController(text: initialText);

    return TextField(
      controller: effectiveController,
      maxLines: maxLines,
      minLines: minLines ?? 2,
      keyboardType: TextInputType.multiline,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white38),
        border: border,
        contentPadding: const EdgeInsets.all(12),
      ),
      focusNode: focusNode,
    );
  }
}
