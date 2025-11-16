import 'package:flutter/material.dart';

import 'SimpleSwitch.dart';

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

  void _handleSwitchChanged(bool newValue) async {
    /* 呼び出し側でいろいろチェックして、controller.valueを適切に設定する */
    final status = await widget.onWillChange(newValue);
    _controller.value = status;
    // if (!newValue) {
    //   final confirm = await showDialog<bool>(
    //     context: context,
    //     barrierDismissible: true,
    //     builder:
    //         (context) => AlertDialog(
    //           title: Text("保存しますか？"),
    //           content: Text("データを保存してから切り替えますか？"),
    //           actions: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 TextButton(
    //                   onPressed: () => Navigator.pop(context, false),
    //                   child: Text("キャンセル"),
    //                 ),
    //                 TextButton(
    //                   onPressed: () => Navigator.pop(context, true),
    //                   child: Text("保存する"),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //   );
    //
    //   print("selected confirm:$confirm");
    //   if (confirm == true) {
    //     // 呼び出し側でチェックして、許可された場合のみ状態を変更
    //     final shouldChange = await widget.onWillChange(false, true);
    //     if (shouldChange) {
    //       _controller.value = false;
    //     } else {
    //       // 変更が拒否された場合は元の状態に戻す
    //       _controller.value = true;
    //     }
    //   } else if (confirm == false) {
    //     // 呼び出し側でチェックして、許可された場合のみ状態を変更
    //     final shouldChange = await widget.onWillChange(false, false);
    //     if (shouldChange) {
    //       _controller.value = false;
    //     } else {
    //       // 変更が拒否された場合は元の状態に戻す
    //       _controller.value = true;
    //     }
    //   } else {
    //     //nullのときは何もしない状態を変えない。
    //     // confirm が null ならば状態は変更しない（元の状態に戻す）
    //     _controller.value = true;
    //   }
    // } else {
    //   // falseからtrueへの変更時も呼び出し側でチェック
    //   final shouldChange = await widget.onWillChange(true, null);
    //   if (shouldChange) {
    //     _controller.value = true;
    //   } else {
    //     // 変更が拒否された場合は元の状態に戻す
    //     _controller.value = false;
    //   }
    // }
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
