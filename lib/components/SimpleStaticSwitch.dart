import 'package:flutter/material.dart';

class SimpleStaticSwitch extends StatelessWidget {
  final bool value;
  final double width;
  final double height;

  const SimpleStaticSwitch({
    required this.value,
    this.width = 60,
    this.height = 30,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        color:
            value
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: height - 8,
          height: height - 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
