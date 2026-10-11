import 'package:flutter/material.dart';

/// 画面内のまとまりの見出し(アイコン + タイトル + 右端の補足)
class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;

  const SectionHeader({required this.icon, required this.title, this.trailing, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.primary),
            ),
          ),
          if (trailing != null) Text(trailing!, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
