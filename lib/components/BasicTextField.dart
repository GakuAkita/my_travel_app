import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicTextField extends StatelessWidget {
  const BasicTextField({
    this.autofocus = false,
    this.obscureText = false,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.initialValue,
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

  @override
  Widget build(BuildContext context) {
    final effectiveController =
        controller ?? TextEditingController(text: initialValue);

    return TextField(
      controller: effectiveController,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters:
          inputFormatters ?? [FilteringTextInputFormatter.allow(RegExp(r'.*'))],
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(),
      ),
      autofocus: autofocus,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}
