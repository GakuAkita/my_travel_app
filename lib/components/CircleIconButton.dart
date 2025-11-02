import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // ボタンがタップされたときの動作
      child: Container(
        width: 56.0, // 円のサイズ
        height: 56.0, // 円のサイズ
        decoration: BoxDecoration(
          shape: BoxShape.circle, // 円形にする
          color: Theme.of(context).colorScheme.primary, // ボタンの色
        ),
        child: Icon(
          icon,
          color: Colors.white, // アイコンの色
          size: 30.0, // アイコンのサイズ
        ),
      ),
    );
  }
}
