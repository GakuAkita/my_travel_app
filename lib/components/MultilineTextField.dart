import 'package:flutter/material.dart';

class MultilineTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String initialText;
  final String hintText;
  final int? maxLines;
  final int? minLines;
  final InputBorder border;
  final FocusNode? focusNode;
  final void Function(String content) onChanged;

  const MultilineTextField({
    super.key,
    this.controller,
    this.initialText = '',
    /* コントローラが渡されている場合はinitialTextは無視 */
    this.hintText = '',
    this.maxLines,
    this.minLines,
    this.focusNode,
    this.border = const OutlineInputBorder(),
    required this.onChanged,
  });

  @override
  State<MultilineTextField> createState() => _MultilineTextFieldState();
}

class _MultilineTextFieldState extends State<MultilineTextField> {
  late final TextEditingController _controller;
  late final bool _isExternal;

  @override
  void initState() {
    super.initState();
    _isExternal = widget.controller != null;

    _controller = widget.controller ?? TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    if (!_isExternal) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: widget.maxLines,
      minLines: widget.minLines ?? 2,
      keyboardType: TextInputType.multiline,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.white38),
        border: widget.border,
        contentPadding: const EdgeInsets.all(12),
      ),
      focusNode: widget.focusNode,
    );
  }
}
