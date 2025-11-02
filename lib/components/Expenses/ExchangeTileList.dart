import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/MoneyExchange.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/components/BasicText.dart';

class ExchangeTileList extends StatelessWidget {
  final List<MoneyExchange> exgData;
  final Map<String, TravelerBasic> participants;
  ExchangeTileList({
    required this.exgData,
    required this.participants,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (exgData.isEmpty) {
      return Center(child: Text("割り勘データがありません"));
    }

    return Column(
      children:
          exgData.map((exchange) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: Card(
                child: ListTile(
                  title: SenderReceiverLine(
                    sender: TravelerBasic.getProfileNameFromUid(
                      exchange.sender,
                      participants,
                    ),
                    receiver: TravelerBasic.getProfileNameFromUid(
                      exchange.receiver,
                      participants,
                    ),
                  ),
                  subtitle: BasicText(text: "金額${exchange.amount.toInt()}円"),
                ),
              ),
            );
          }).toList(),
    );
  }
}

class SenderReceiverLine extends StatelessWidget {
  final String sender;
  final String receiver;

  SenderReceiverLine({required this.sender, required this.receiver});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: BasicText(text: sender)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.arrow_forward),
        ),
        Expanded(child: BasicText(text: receiver)),
      ],
    );
  }
}
