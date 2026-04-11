class ExpenseDetail {
  final String expenseId;
  final String expenseItem;

  final double paidAmount;
  final double owedAmount;

  double get balance => paidAmount - owedAmount;

  ExpenseDetail({
    required this.expenseId,
    required this.expenseItem,
    required this.paidAmount,
    required this.owedAmount,
  });
}
