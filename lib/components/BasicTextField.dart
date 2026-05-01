import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicTextField extends StatefulWidget {
  const BasicTextField({
    this.autofocus = false,
    this.obscureText = false,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.initialValue,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    required this.hintText,
    required this.onChanged,
    super.key,
  });

  final String hintText;
  final bool obscureText;
  final bool autofocus;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? initialValue;
  final FocusNode? focusNode;
  final bool enabled;
  final bool readOnly;

  @override
  State<BasicTextField> createState() => _BasicTextFieldState();
}

class _BasicTextFieldState extends State<BasicTextField> {
  late TextEditingController _controller;
  late bool _isExternal;

  @override
  void initState() {
    super.initState();
    _isExternal = widget.controller != null;

    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    if (!_isExternal) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BasicTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      if (!_isExternal) {
        _controller.dispose();
      }

      _isExternal = widget.controller != null;
      _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      inputFormatters: widget.inputFormatters ?? [FilteringTextInputFormatter.allow(RegExp(r'.*'))],
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(),
      ),
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
    );
  }
}
