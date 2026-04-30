import 'package:flutter/material.dart';
import 'package:my_travel_app/components/SimpleTextButton.dart';

class ItineraryTableEditButton extends StatelessWidget {
  VoidCallback? onPressed;

  ItineraryTableEditButton({this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SimpleTextButton(
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.primary)),
          height: 100,
          child: Center(
            child: Text("テーブル\nタップして編集", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ),
        ),
      ),
    );
  }
}
