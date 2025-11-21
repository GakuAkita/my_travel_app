import 'package:flutter/material.dart';

import 'ControlledSwitch.dart';

/**
 * falseからtrueにいれるときはすんなりいくが、
 * trueからfalseにいくときは保存orキャンセルの選択により実行する内容が変化
 */
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
  late final ValueNotifier<bool> _controller;

  @override
  void initState() {
    super.initState();
    _controller = ValueNotifier(widget.initialStatus);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    print("handleTap started??");
    if (!widget.isEnabled) return;

    // 現在の状態を反転させた新しい値
    final newValue = !_controller.value;

    // onWillChangeで確認
    final status = await widget.onWillChange(newValue);

    // OKが出たら状態を更新
    _controller.value = status;
  }

  @override
  Widget build(BuildContext context) {
    final switchWidget = ControlledSwitch(
      width: widget.width,
      height: widget.height,
      isEnabled: widget.isEnabled,
      controller: _controller, // 👈 渡す
    );

    // GestureDetectorでタップを制御
    return GestureDetector(onTap: _handleTap, child: switchWidget);
  }
}
