import 'package:flutter/material.dart';

/// 設定画面の1行。アイコン + メニュー名 + 右矢印
class SettingMenubar extends StatelessWidget {
  final String menuName;
  final VoidCallback onPressed;
  final IconData? icon;
  final String? subtitle;

  const SettingMenubar({required this.onPressed, required this.menuName, this.icon, this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: icon != null ? Icon(icon, color: colorScheme.primary) : null,
      title: Text(menuName),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant))
          : null,
      trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
      onTap: onPressed,
    );
  }
}
