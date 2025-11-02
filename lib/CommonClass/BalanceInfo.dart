class BalancesInfo {
  final String uid;
  final double netTotal;
  final double reimbursedSum;
  final double paidSum;

  BalancesInfo({
    required this.uid,
    required this.netTotal,
    required this.reimbursedSum,
    required this.paidSum,
  });

  static BalancesInfo convFromMap(Map<dynamic, dynamic> map) {
    return BalancesInfo(
      uid: map["uid"],
      netTotal: map["netTotal"].toDouble(),
      reimbursedSum: map["reimbursedSum"].toDouble(),
      paidSum: map["paidSum"].toDouble(),
    );
  }
}
