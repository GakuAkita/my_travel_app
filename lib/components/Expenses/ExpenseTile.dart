import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/ExpenseInfo.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/screens/Main/Expenses/AddEditExpenseScreen.dart';
import 'package:my_travel_app/utils/UidColorHelper.dart';

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

  List<Widget> _buildReimbursedBadges(BuildContext context) {
    final List<String> uids = expense.reimbursedBy.keys.toList();
    if (uids.isEmpty) return [];

    // members全体でのUIDの順序を取得
    final Map<String, int> uidColorIndexMap =
        UidColorHelper.getUidColorIndexMap(members);

    return uids.map((uid) {
      String head = TravelerBasic.getProfileNameFromUid(uid, members);
      if (head.length >= 2) {
        head = head.substring(0, 2);
      }

      final badgeColor = UidColorHelper.getColorForUid(uid, uidColorIndexMap);
      final textColor = UidColorHelper.getTextColorForUid(
        uid,
        uidColorIndexMap,
      );

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
                            getProfileNameFromUid(expense.payer.uid),
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
