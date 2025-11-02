import 'package:flutter/material.dart';

class ScrollableDialog extends StatelessWidget {
  final Widget? head;
  final Widget child;

  const ScrollableDialog({super.key, this.head, required this.child});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (head != null) head!,
              //GPTに作ってもらった
              // 高さを制限してスクロールを有効にする
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height * 0.6, // 最大高さ60%に制限
                ),
                child: SingleChildScrollView(child: child),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
