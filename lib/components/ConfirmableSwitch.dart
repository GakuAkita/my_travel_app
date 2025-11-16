import 'package:flutter/material.dart';

import 'SimpleSwitch.dart';

/**
 * falseからtrueにいれるときはすんなりいくが、
 * trueからfalseにいくときは保存orキャンセルの選択により実行する内容が変化
 */
class ConfirmableSwitch extends StatefulWidget {
  final double? width;
  final double? height;
  final bool isEnabled;
  final bool initialStatus;
  final void Function(bool status, bool? response) onConfirmedChanged;

  const ConfirmableSwitch({
    this.width,
    this.height,
    this.isEnabled = true,
    this.initialStatus = false,
    required this.onConfirmedChanged,
    super.key,
  });

  @override
  State<ConfirmableSwitch> createState() => _ConfirmableSwitchState();
}

class _ConfirmableSwitchState extends State<ConfirmableSwitch> {
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

  void _handleSwitchChanged(bool newValue) async {
    if (!newValue) {
      final confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder:
            (context) => AlertDialog(
              title: Text("保存しますか？"),
              content: Text("データを保存してから切り替えますか？"),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("キャンセル"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text("保存する"),
                    ),
                  ],
                ),
              ],
            ),
      );

      print("selected confirm:$confirm");
      if (confirm == true) {
        _controller.value = false;
        widget.onConfirmedChanged(false, true);
      } else if (confirm == false) {
        _controller.value = false;
        widget.onConfirmedChanged(false, false);
      } else {
        //nullのときは何もしない状態を変えない。
        // confirm が null ならば状態は変更しない（元の状態に戻す）
        _controller.value = true;
      }
    } else {
      _controller.value = true;
      widget.onConfirmedChanged(true, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleSwitch(
      width: widget.width,
      height: widget.height,
      isEnabled: widget.isEnabled,
      initialValue: widget.initialStatus,
      controller: _controller, // 👈 渡す
      onChanged: _handleSwitchChanged,
    );
  }
}
