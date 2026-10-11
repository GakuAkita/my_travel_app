import 'package:flutter/material.dart';

class ItineraryTableEditButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ItineraryTableEditButton({this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.primary.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.table_chart_outlined, color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "テーブル",
                      style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600),
                    ),
                    Text("タップして編集", style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
