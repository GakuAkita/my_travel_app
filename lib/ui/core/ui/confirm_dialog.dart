import 'package:flutter/material.dart';

/// 削除などの取り消せない操作の前に確認する。OKならtrue
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = true,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("キャンセル")),
          FilledButton(
            style: destructive
                ? FilledButton.styleFrom(backgroundColor: colorScheme.error, foregroundColor: colorScheme.onError)
                : null,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}
