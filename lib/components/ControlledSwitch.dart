import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class ControlledSwitch extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isEnabled;
  final ValueNotifier<bool> controller;

  const ControlledSwitch({
    this.width,
    this.height,
    this.isEnabled = true,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final switchWidget = AdvancedSwitch(
      controller: controller,
      width: width ?? 100,
      height: height ?? 40,
      activeColor: Theme.of(context).colorScheme.primary,
      inactiveColor: Theme.of(context).colorScheme.onPrimary,
      borderRadius: BorderRadius.circular(15),
    );

    return IgnorePointer(ignoring: true, child: switchWidget);
  }
}
