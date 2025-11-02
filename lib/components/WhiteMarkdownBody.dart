import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class WhiteMarkdownBody extends StatelessWidget {
  final String data;
  final void Function(String, String?, String)? onTapLink;
  final bool selectable;

  const WhiteMarkdownBody({
    required this.data,
    this.onTapLink,
    this.selectable = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // デフォルトで h1~h3を白色に設定
    const headerStyle = TextStyle(color: Colors.white);

    return MarkdownBody(
      data: data,
      onTapLink: onTapLink,
      selectable: selectable,
      styleSheet: MarkdownStyleSheet.fromTheme(
        Theme.of(context),
      ).copyWith(h1: headerStyle, h2: headerStyle, h3: headerStyle),
    );
  }
}
