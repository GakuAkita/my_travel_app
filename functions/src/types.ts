export interface TravelerBasic {
  uid: string;
  email: string;
  profile_name?: string;
}

export interface ExpenseInfo {
  id: string;
  createdAt: string;
  expense: number;
  expenseItem: string;
  payer: TravelerBasic;
  reimbursedBy: Record<string, Record<string, string>>;
}

export interface MoneyExchangeType {
  sender: string;
  receiver: string;
  amount: number;
}

export interface BalanceInfo {
  uid: String;
  netTotal: number;
  paidSum: number;
  reimbursedSum: number;
}

export type ExpenseData = Record<string, ExpenseInfo>;
export type BalanceType = Record<string, BalanceInfo>;
