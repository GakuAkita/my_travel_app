import 'package:flutter/material.dart';

class SimpleTextButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  SimpleTextButton({super.key, required this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: child,
    );
  }
}
