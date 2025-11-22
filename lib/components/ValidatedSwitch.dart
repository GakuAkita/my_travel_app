import 'package:flutter/cupertino.dart';

import 'SimpleStaticSwitch.dart';

class ValidatedSwitch extends StatefulWidget {
  final double? width;
  final double? height;
  final bool isEnabled;
  final bool initialStatus;
  final Future<bool> Function(bool newValue) onWillChange;

  const ValidatedSwitch({
    this.width,
    this.height,
    this.isEnabled = true,
    this.initialStatus = false,
    required this.onWillChange,
    super.key,
  });

  @override
  State<ValidatedSwitch> createState() => _ValidatedSwitchState();
}

class _ValidatedSwitchState extends State<ValidatedSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialStatus;
  }

  void _handleTap() async {
    if (!widget.isEnabled) return;

    final newValue = !_value;

    // onWillChange で確認
    final shouldApply = await widget.onWillChange(newValue);

    // OKなら反映、キャンセルなら現状維持
    setState(() {
      _value = shouldApply;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: SimpleStaticSwitch(
        value: _value,
        width: widget.width ?? 60,
        height: widget.height ?? 30,
      ),
    );
  }
}
