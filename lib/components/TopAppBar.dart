import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({
    this.title = '精神的なこと、これも技術のうち。',
    this.centerTitle = false,
    this.automaticallyImplyLeading = false,
    super.key,
  });

  final String title;
  final bool centerTitle;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle(fontSize: 20)),
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
