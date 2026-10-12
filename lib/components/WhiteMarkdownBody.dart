import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

/* テキスト選択したい場合は呼び出し側で SelectionArea で囲むこと
   (MarkdownBodyのselectableはブロックごとに選択範囲が分断されるため使わない) */
class WhiteMarkdownBody extends StatelessWidget {
  final String data;
  final void Function(String, String?, String)? onTapLink;

  const WhiteMarkdownBody({required this.data, this.onTapLink, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // デフォルトで h1~h3を白色に設定
    const headerStyle = TextStyle(color: Colors.white);

    return MarkdownBody(
      data: data,
      onTapLink: onTapLink,
      styleSheet: MarkdownStyleSheet.fromTheme(
        Theme.of(context),
      ).copyWith(h1: headerStyle, h2: headerStyle, h3: headerStyle),
    );
  }
}
