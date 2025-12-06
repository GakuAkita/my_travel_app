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
  late final intOnly;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue?.toString() ?? '',
    );
    intOnly = widget.intOnly;
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
          if (newValue.text.split('.').length > 2) {
            return oldValue;
          }
          return newValue;
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
