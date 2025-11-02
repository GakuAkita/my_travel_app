import 'package:flutter/material.dart';

class SettingMenubar extends StatelessWidget {
  final String menuName;
  final VoidCallback onPressed;

  SettingMenubar({required this.onPressed, required this.menuName, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(children: [Text(menuName)]),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
