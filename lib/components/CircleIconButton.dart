import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double radius;

  CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.radius = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // ボタンがタップされたときの動作
      child: Container(
        width: radius, // 円のサイズ
        height: radius, // 円のサイズ
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
