import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/MoneyExchange.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/utils/UidColorHelper.dart';

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
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              "割り勘データがありません",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    final uidColorIndexMap = UidColorHelper.getUidColorIndexMap(participants);
    final theme = Theme.of(context);

    return Column(
      children:
          exgData.map((exchange) {
            final senderName = TravelerBasic.getProfileNameFromUid(
              exchange.sender,
              participants,
            );
            final receiverName = TravelerBasic.getProfileNameFromUid(
              exchange.receiver,
              participants,
            );

            final senderColor = UidColorHelper.getColorForUid(
              exchange.sender,
              uidColorIndexMap,
            );
            final receiverColor = UidColorHelper.getColorForUid(
              exchange.receiver,
              uidColorIndexMap,
            );

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // 送信者
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: senderColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              senderName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: UidColorHelper.getTextColorForUid(
                                  exchange.sender,
                                  uidColorIndexMap,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 矢印と金額
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "¥${exchange.amount.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 受信者
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: receiverColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              receiverName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: UidColorHelper.getTextColorForUid(
                                  exchange.receiver,
                                  uidColorIndexMap,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
