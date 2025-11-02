import 'package:flutter/material.dart';

class BasicText extends StatelessWidget {
  BasicText({required this.text, this.overflow, super.key});

  final String text;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(text, overflow: overflow, style: TextStyle(fontSize: 18));
  }
}
