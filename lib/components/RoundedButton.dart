import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    required this.title,
    required this.onPressed,
    this.enabled = true,
    this.textStyle = const TextStyle(fontSize: 20),
    this.buttonStyle,
    super.key,
  });

  final String title;
  final VoidCallback onPressed;
  final bool enabled;
  final TextStyle textStyle;
  final ButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context) {
    final baseStyle = buttonStyle ?? ElevatedButton.styleFrom();

    final disabledStyle = baseStyle.copyWith(
      backgroundColor: WidgetStatePropertyAll(Colors.grey[800]),
      foregroundColor: WidgetStatePropertyAll(Colors.grey[600]),
    );

    return ElevatedButton(
      onPressed:
          enabled ? onPressed : null, //enabledがfalseならonPressに何が入っていようがnull
      style: enabled ? baseStyle : disabledStyle,
      child: Text(title, style: textStyle),
    );
  }
}
