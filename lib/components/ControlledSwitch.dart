import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

/**
 * ValidatedSwitch専用のスイッチコンポーネント
 * 直接タップを無効化し、外部のGestureDetectorで制御するためのもの
 */
class ControlledSwitch extends StatefulWidget {
  final double? width;
  final double? height;
  final bool isEnabled;
  final bool initialValue;
  final ValueNotifier<bool> controller; // 👈 必須（外部から制御するため）

  const ControlledSwitch({
    this.width,
    this.height,
    this.isEnabled = true,
    required this.initialValue,
    required this.controller,
    super.key,
  });

  @override
  State<ControlledSwitch> createState() => _ControlledSwitchState();
}

class _ControlledSwitchState extends State<ControlledSwitch> {
  @override
  void initState() {
    super.initState();
    // 初期値をコントローラに設定
    widget.controller.value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final switchWidget = AdvancedSwitch(
      controller: widget.controller,
      initialValue: widget.controller.value,
      width: widget.width ?? 100,
      height: widget.height ?? 40,
      activeColor: Theme.of(context).colorScheme.primary,
      inactiveColor: Theme.of(context).colorScheme.onPrimary,
      borderRadius: BorderRadius.circular(15),
      // onChangedは設定しない（直接タップを無効化）
    );

    // isEnabledがfalseの場合はAbsorbPointerで無効化
    if (!widget.isEnabled) {
      return AbsorbPointer(absorbing: true, child: switchWidget);
    }

    // 直接タップを無効化（GestureDetectorで制御するため）
    return IgnorePointer(ignoring: true, child: switchWidget);
  }
}
