import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:my_travel_app/components/BasicTextField.dart';

class NumberField extends StatefulWidget {
  const NumberField({
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.intOnly = false,
    this.minValue,
    this.maxValue,
    this.controller,
    super.key,
  });

  final String? hintText;
  final double? initialValue;

  /* ２つ目の引数はmin,maxがあったときに範囲外になっているかどうかを返す */
  final Function(double)? onChanged;
  final bool intOnly;
  final double? minValue;
  final double? maxValue;
  final TextEditingController? controller;

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final bool _isExternalController;

  @override
  void initState() {
    super.initState();
    String initialText;
    if (widget.intOnly && widget.initialValue != null) {
      initialText = widget.initialValue!.toInt().toString();
    } else {
      initialText = widget.initialValue?.toString() ?? '';
    }

    _isExternalController = widget.controller != null;
    _controller = widget.controller ?? TextEditingController();
    _controller.text = initialText;
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();

    if (!_isExternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      final text = _controller.text;
      var value = double.tryParse(text);

      if (value != null) {
        var clampedValue = value;
        if (widget.minValue != null) {
          clampedValue = max(widget.minValue!, clampedValue);
        }
        if (widget.maxValue != null) {
          clampedValue = min(widget.maxValue!, clampedValue);
        }

        if (clampedValue != value) {
          final newText =
              widget.intOnly
                  ? clampedValue.toInt().toString()
                  : clampedValue.toString();
          _controller.text = newText;
        }

        if (widget.onChanged != null) {
          widget.onChanged!(clampedValue);
        }
      } else {
        // Handle cases where the text is empty or invalid on unfocus (e.g., ".")
        final double fallbackValue = widget.minValue ?? 0.0;
        final newText =
            widget.intOnly
                ? fallbackValue.toInt().toString()
                : fallbackValue.toString();
        _controller.text = newText;
        if (widget.onChanged != null) {
          widget.onChanged!(fallbackValue);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasicTextField(
      focusNode: _focusNode,
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
        } else if (strValue.isEmpty) {
          // If the field is cleared, treat it as 0.
          widget.onChanged!(0.0);
        } else {}
      },
    );
  }
}
