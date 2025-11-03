import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/ExpenseInfo.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/screens/Main/Expenses/AddEditExpenseScreen.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseInfo expense;
  final Map<String, TravelerBasic> members;

  ExpenseTile({required this.expense, required this.members, super.key});

  String getProfileNameFromUid(String uid) {
    if (members[uid] == null) {
      return "*"; /*uidが見つからなかった時*/
    }
    String nameShown = members[uid]!.profile_name ?? members[uid]!.email;

    return nameShown;
  }

  int _betterHash(String str) {
    // より分散の良いハッシュ関数
    int hash = 0;
    for (int i = 0; i < str.length; i++) {
      hash = ((hash << 5) - hash) + str.codeUnitAt(i);
      hash = hash & hash; // Convert to 32bit integer
    }
    return hash;
  }

  List<Widget> _buildReimbursedBadges(BuildContext context) {
    final List<String> uids = expense.reimbursedBy.keys.toList();
    if (uids.isEmpty) return [];

    // 基本となる色のリスト（Material Designの色相から）
    final List<Color> colorPalette = [
      Color.fromARGB(255, 232, 245, 233), // Light Green
      Color.fromARGB(255, 227, 242, 253), // Light Blue
      Color.fromARGB(255, 255, 243, 224), // Light Orange
      Color.fromARGB(255, 245, 224, 233), // Light Pink
      Color.fromARGB(255, 237, 231, 246), // Light Purple
      Color.fromARGB(255, 255, 236, 179), // Light Amber
      Color.fromARGB(255, 224, 247, 250), // Light Cyan
      Color.fromARGB(255, 255, 228, 225), // Light Red
    ];

    final List<Color> textColorPalette = [
      Color.fromARGB(255, 27, 94, 32), // Dark Green
      Color.fromARGB(255, 13, 71, 161), // Dark Blue
      Color.fromARGB(255, 230, 81, 0), // Dark Orange
      Color.fromARGB(255, 136, 14, 79), // Dark Pink
      Color.fromARGB(255, 74, 20, 140), // Dark Purple
      Color.fromARGB(255, 255, 143, 0), // Dark Amber
      Color.fromARGB(255, 0, 96, 100), // Dark Cyan
      Color.fromARGB(255, 183, 28, 28), // Dark Red
    ];

    return uids.map((uid) {
      // UIDのハッシュ値から直接色を決定（同じUIDには常に同じ色）
      int colorIndex = _betterHash(uid).abs() % colorPalette.length;

      String head = TravelerBasic.getProfileNameFromUid(uid, members);
      if (head.length >= 2) {
        head = head.substring(0, 2);
      }

      final badgeColor = colorPalette[colorIndex];
      final textColor = textColorPalette[colorIndex];

      return Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          head,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AddEditExpenseScreen.id,
            arguments: {"expenseId": expense.id},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Left section: Item name and payer info
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expense item name
                    Text(
                      expense.expenseItem,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Payer info
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            expense.payer.profile_name ?? expense.payer.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // Reimbursed badges
                    if (expense.reimbursedBy.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          ..._buildReimbursedBadges(context),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Right section: Amount
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "¥${expense.expense.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onInverseSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
