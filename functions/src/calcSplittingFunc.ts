import { BalanceType, ExpenseData, MoneyExchangeType } from "./types";

export const calcBalances = (expenses: ExpenseData): BalanceType => {
  const balances: BalanceType = {};

  for (const expense of Object.values(expenses)) {
    const payerId = expense.payer.uid;
    const involvedUids = Object.keys(expense.reimbursedBy);
    const shareAmount = expense.expense / involvedUids.length;

    for (const uid of involvedUids) {
      if (!balances[uid]) {
        //まだuidが初期化されていなかったら追加する
        balances[uid] = { uid: uid, netTotal: 0, paidSum: 0, reimbursedSum: 0 };
      }

      balances[uid].reimbursedSum += shareAmount; //受け取る総額が
      balances[uid].netTotal -= shareAmount; //最終的な損得
    }

    if (!balances[payerId]) {
      //uidがなかった初期化
      balances[payerId] = {
        uid: payerId,
        netTotal: 0,
        paidSum: 0,
        reimbursedSum: 0,
      };
    }

    balances[payerId].paidSum += expense.expense; //支払い合計
    balances[payerId].netTotal += expense.expense; //最終的な損得
  }

  return balances;
};

export const calcMoneyExchange = (
  originalBalances: BalanceType
): Array<MoneyExchangeType> => {
  /**
   * そのまま引数のbalancesを変更してしまうと、引数側の値も変わってしまう。したがって、
   * ここで一回コピーを作ってそれを以降使用する。
   */
  const balances: BalanceType = JSON.parse(JSON.stringify(originalBalances));
  const exchanges: Array<MoneyExchangeType> = [];

  // netTotal を基に正（払いすぎ）と負（払い足りない）に分類
  const creditors: Array<{ id: string; amount: number }> = [];
  const debtors: Array<{ id: string; amount: number }> = [];

  for (const [id, balance] of Object.entries(balances)) {
    const net = Math.round(balance.netTotal); //整数にしたければ
    if (net > 0) {
      creditors.push({ id, amount: net });
    } else if (net < 0) {
      debtors.push({ id, amount: -net }); //正の額に直す
    }
  }

  // 借りてる人から返していく
  while (creditors.length > 0 && debtors.length > 0) {
    const creditor = creditors[0];
    const debtor = debtors[0];

    const amount = Math.min(creditor.amount, debtor.amount);

    exchanges.push({
      sender: debtor.id,
      receiver: creditor.id,
      amount: amount,
    });

    creditor.amount -= amount;
    debtor.amount -= amount;

    if (creditor.amount === 0) creditors.shift();
    if (debtor.amount === 0) debtors.shift();
  }

  return exchanges;
};

// /* 使い方としてはこんな感じ。 */
// const calcSplittingFunc = (expenses: ExpenseData) => {
//   const balances: BalanceType = calcBalances(expenses);
//   console.log(balances);

//   const exchanges: Array<MoneyTransferType> = calcMoneyExchange(balances);
//   console.log("exchanges:", exchanges);

//   /* 計算結果をRealtimeDatabaseに追加する */
// };
