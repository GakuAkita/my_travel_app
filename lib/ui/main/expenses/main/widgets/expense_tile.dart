import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/UidColorHelper.dart';
import '../../../../../core/utils/currency_format.dart';
import '../../../../../data/model/expense/expense_info.dart';
import '../../../../../data/model/traveler/traveler_basic.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseInfo expense;
  final Map<String, TravelerBasic> members;
  final VoidCallback? onTap;

  const ExpenseTile({
    required this.expense,
    required this.members,
    this.onTap,
    super.key,
  });

  String getProfileNameFromUid(String uid) {
    if (members[uid] == null) {
      return "*"; /*uidが見つからなかった時*/
    }
    return members[uid]!.displayName;
  }

  /* 名前の先頭2文字 */
  String _nameHead(String uid) {
    final name = getProfileNameFromUid(uid);
    return name.length >= 2 ? name.substring(0, 2) : name;
  }

  /* 支払った人 · 日付 */
  String _subtitle() {
    final payerName = getProfileNameFromUid(expense.payer.uid);
    final createdAt = expense.createdAt;
    if (createdAt == null) return "$payerName が支払い";
    final date = DateFormat('M/d').format(DateTime.fromMillisecondsSinceEpoch(createdAt));
    return "$payerName が支払い · $date";
  }

  Widget _badge({required String text, required Color background, required Color foreground}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(12)),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: foreground),
      ),
    );
  }

  List<Widget> _buildReimbursedBadges(BuildContext context, Map<String, int> uidColorIndexMap) {
    final List<String> uids = expense.reimbursedBy.keys.toList();
    if (uids.isEmpty) return [];

    /* グループメンバー全員で割る場合はまとめて表示する */
    final isEveryone = members.isNotEmpty && members.keys.every(expense.reimbursedBy.containsKey);
    if (isEveryone) {
      final colorScheme = Theme.of(context).colorScheme;
      return [
        _badge(
          text: "全員 (${uids.length}人)",
          background: colorScheme.primary.withValues(alpha: 0.2),
          foreground: colorScheme.primary,
        ),
      ];
    }

    return uids.map((uid) {
      return _badge(
        text: _nameHead(uid),
        background: UidColorHelper.getColorForUid(uid, uidColorIndexMap),
        foreground: UidColorHelper.getTextColorForUid(uid, uidColorIndexMap),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // members全体でのUIDの順序を取得
    final Map<String, int> uidColorIndexMap = UidColorHelper.getUidColorIndexMap(members);
    final payerUid = expense.payer.uid;
    final splitCount = expense.reimbursedBy.length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 支払った人のアバター
              CircleAvatar(
                radius: 20,
                backgroundColor: UidColorHelper.getColorForUid(payerUid, uidColorIndexMap),
                child: Text(
                  _nameHead(payerUid),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: UidColorHelper.getTextColorForUid(payerUid, uidColorIndexMap),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.expenseItem,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _subtitle(),
                      style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // 割り勘する人
                    if (expense.reimbursedBy.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.group_outlined, size: 16, color: colorScheme.onSurfaceVariant),
                          ..._buildReimbursedBadges(context, uidColorIndexMap),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // 金額
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatYen(expense.expense),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (splitCount >= 2)
                    Text(
                      "1人 ${formatYen(expense.expense / splitCount)}",
                      style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
