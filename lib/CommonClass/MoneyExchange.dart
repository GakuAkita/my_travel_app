class MoneyExchange {
  final String sender;
  final String receiver;
  final double amount;

  MoneyExchange({
    required this.sender,
    required this.receiver,
    required this.amount,
  });

  static MoneyExchange convFromMap(Map<dynamic, dynamic> map) {
    return MoneyExchange(
      sender: map["sender"],
      receiver: map["receiver"],
      amount: map["amount"].toDouble(), //intで入っている可能性もある
    );
  }
}
