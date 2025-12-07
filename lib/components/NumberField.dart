import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:my_travel_app/components/BasicTextField.dart';

class NumberField extends StatefulWidget {
  const NumberField({
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.intOnly = false,
    super.key,
  });

  final String? hintText;
  final double? initialValue;
  final Function(double)? onChanged;
  final bool intOnly;

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    String initialText;
    if (widget.intOnly && widget.initialValue != null) {
      initialText = widget.initialValue!.toInt().toString();
    } else {
      initialText = widget.initialValue?.toString() ?? '';
    }

    _controller = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicTextField(
      controller: _controller,
      hintText: widget.hintText ?? "",
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        // Allow only digits and a single dot
        FilteringTextInputFormatter.allow(
          RegExp(widget.intOnly ? r'[0-9]' : r'[0-9.]'),
        ),
        // Prevent multiple dots
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (widget.intOnly) {
            final text = newValue.text;
            if (text.isEmpty) {
              return newValue;
            }
            // Normalize the input to prevent leading zeros like "05" or "00".
            final number = int.tryParse(text);
            if (number == null) {
              return oldValue; // Should not happen.
            }
            final normalizedText = number.toString();
            if (normalizedText != text) {
              // The text was changed (e.g. "05" -> "5"), update the text field.
              return newValue.copyWith(
                text: normalizedText,
                selection: TextSelection.collapsed(
                  offset: normalizedText.length,
                ),
              );
            }
            return newValue;
          } else {
            // Prevent multiple dots for decimal input.
            if (newValue.text.split('.').length > 2) {
              return oldValue;
            }
            return newValue;
          }
        }),
      ],
      onChanged: (strValue) {
        if (widget.onChanged == null) return;

        final value = double.tryParse(strValue);
        if (value != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}
