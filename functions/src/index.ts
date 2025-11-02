import * as admin from "firebase-admin";
import { onValueWritten } from "firebase-functions/database";
import { setGlobalOptions } from "firebase-functions/v2";
import { calcBalances, calcMoneyExchange } from "./calcSplittingFunc";
import { BalanceType, ExpenseData, MoneyExchangeType } from "./types";

admin.initializeApp();
setGlobalOptions({ region: "asia-southeast1" });

// Realtime Databaseの変更を監視する
export const onExpenseDataChange = onValueWritten(
  "/groups/{groupId}/travels/{travelId}/expenses/data/",
  async (event) => {
    const currentData = event.data.after.val() as ExpenseData;
    const { groupId, travelId } = event.params;

    /* RealtimeDbへアップロード */
    const expensesRef = admin
      .database()
      .ref(`/groups/${groupId}/travels/${travelId}/expenses/`);
    const balancesRef = expensesRef.child("balances");
    const exchangeRef = expensesRef.child("exchanges");
    const exchangeResultRef = exchangeRef.child("result");
    // currentDataが空かをチェック（null または 空オブジェクト）
    if (!currentData || Object.keys(currentData).length === 0) {
      console.log("currentData is empty, removing balances and exchange");
      await balancesRef.remove();
      await exchangeRef.remove();
      return null;
    }

    console.log("current Data↓");
    console.log(currentData);

    /* expensesの損得を合計する */
    console.log("calcBalances Start!!!");
    const balances: BalanceType = calcBalances(currentData);
    console.log(balances);

    const exchanges: Array<MoneyExchangeType> = calcMoneyExchange(balances);
    console.log(exchanges);

    await balancesRef.set(balances);
    await exchangeResultRef.set(exchanges);

    /* transfer配下に最終更新日時を追加しておく */
    await exchangeRef.update({ lastUpdated: new Date().toISOString() });
    console.log("updated lastUpdated!");

    return null;
  }
);
