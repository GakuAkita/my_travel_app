import 'package:flutter/material.dart';

/// 画面下に固定するメインのボタン。ScaffoldのbottomNavigationBarに渡す
class BottomActionBar extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  /* ボタンの上に出す補足(合計金額など) */
  final Widget? leading;

  const BottomActionBar({required this.label, required this.onPressed, this.leading, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (leading != null) ...[leading!, const SizedBox(height: 8)],
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              onPressed: onPressed,
              child: Text(label, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
