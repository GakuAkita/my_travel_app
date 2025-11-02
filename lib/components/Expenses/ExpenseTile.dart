import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/ExpenseInfo.dart';
import 'package:my_travel_app/CommonClass/TravelerBasic.dart';
import 'package:my_travel_app/components/BasicText.dart';
import 'package:my_travel_app/screens/Main/Expenses/AddEditExpenseScreen.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseInfo expense;
  final Map<String, TravelerBasic> members;

  ExpenseTile({required this.expense, required this.members, super.key});

  String generateHeadStr() {
    //reimbursedByに含まれている人だけほしい
    final List<String> uids = expense.reimbursedBy.keys.toList();
    String reimbursedHead = "";
    for (int i = 0; i < uids.length; i++) {
      //今は先頭文字,先頭文字,...というのを作ろうとしているが、
      //将来的にアイコンを作るとかだと話が変わってくるのでそのときはそれに合わせて改良
      String head = TravelerBasic.getProfileNameFromUid(
        uids[i],
        members,
      ); //頭の2文字だけ返す
      if (head.length >= 2) {
        head = head.substring(0, 2);
      }

      if (i == 0) {
        //最初だけはそのままheadを当てる
        reimbursedHead = head;
      } else {
        reimbursedHead = "${reimbursedHead}, ${head}";
      }
    }
    //.print("reimbursedBy Head:$reimbursedHead");
    return reimbursedHead;
  }

  String getProfileNameFromUid(String uid) {
    if (members[uid] == null) {
      return "*"; /*uidが見つからなかった時*/
    }
    String nameShown = members[uid]!.profile_name ?? members[uid]!.email;

    return nameShown;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[880],
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AddEditExpenseScreen.id,
            arguments: {"expenseId": expense.id},
          );
        },
        child: Row(
          children: [
            // BasicText(text:"${expense.payer.profile_name ?? expense.payer.email}"),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BasicText(
                      text: expense.payer.profile_name ?? expense.payer.email,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text("------------------"),
                    BasicText(text: generateHeadStr()),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 10,
                ),
                child: BasicText(
                  text: "${expense.expense}円",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 10,
                ),
                child: BasicText(
                  text: "${expense.expenseItem}",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
