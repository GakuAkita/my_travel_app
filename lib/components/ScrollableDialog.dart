import 'package:flutter/material.dart';

/// 中身が長くてもスクロールできるダイアログ。下に閉じるボタン
class ScrollableDialog extends StatelessWidget {
  final Widget? head;
  final Widget child;

  const ScrollableDialog({super.key, this.head, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          if (head != null) head!,
          const Divider(height: 1),
          // 高さを制限してスクロールを有効にする
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6), // 最大高さ60%に制限
              child: SingleChildScrollView(child: child),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("閉じる")),
            ),
          ),
        ],
      ),
    );
  }
}
