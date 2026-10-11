import 'package:flutter/material.dart';

/// +を押すと「費用を追加」「まとめて追加」が展開されるFloatingActionButton
class AddExpenseSpeedDial extends StatefulWidget {
  final VoidCallback onAddPressed;
  final VoidCallback onSplitAddPressed;

  const AddExpenseSpeedDial({super.key, required this.onAddPressed, required this.onSplitAddPressed});

  @override
  State<AddExpenseSpeedDial> createState() => _AddExpenseSpeedDialState();
}

class _AddExpenseSpeedDialState extends State<AddExpenseSpeedDial> {
  bool _isOpen = false;

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  /* 選んだら閉じてから実行する */
  void _select(VoidCallback action) {
    setState(() {
      _isOpen = false;
    });
    action();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isOpen) ...[
          _SpeedDialOption(
            label: "まとめて追加",
            icon: Icons.playlist_add,
            heroTag: "split_add",
            onPressed: () => _select(widget.onSplitAddPressed),
          ),
          SizedBox(height: 12),
          _SpeedDialOption(
            label: "費用を追加",
            icon: Icons.add,
            heroTag: "add",
            onPressed: () => _select(widget.onAddPressed),
          ),
          SizedBox(height: 16),
        ],
        FloatingActionButton(
          heroTag: "speed_dial",
          tooltip: _isOpen ? "閉じる" : "追加",
          onPressed: _toggle,
          child: Icon(_isOpen ? Icons.close : Icons.add),
        ),
      ],
    );
  }
}

class _SpeedDialOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final Object heroTag;
  final VoidCallback onPressed;

  const _SpeedDialOption({required this.label, required this.icon, required this.heroTag, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /* ラベルを押しても選べるようにする */
        GestureDetector(
          onTap: onPressed,
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(label),
            ),
          ),
        ),
        SizedBox(width: 12),
        /* メインのボタン(56)と中心を揃える */
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: FloatingActionButton.small(heroTag: heroTag, onPressed: onPressed, child: Icon(icon)),
        ),
      ],
    );
  }
}
