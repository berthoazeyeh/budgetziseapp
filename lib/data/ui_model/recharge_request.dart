class RechargeRequest {
  final String transactionReference;
  final String paymentMethod;
  final double amount;
  final int typeRechargeId;
  final DateTime? rechargeDate;

  RechargeRequest({
    required this.transactionReference,
    required this.paymentMethod,
    required this.amount,
    required this.typeRechargeId,
    this.rechargeDate,
  });

  Map<String, dynamic> toJson() => {
    'transactionReference': transactionReference,
    'paymentMethod': paymentMethod,
    'amount': amount,
    'typeRechargeId': typeRechargeId,
    'rechargeDate': rechargeDate?.toUtc().toIso8601String(),
  };

  factory RechargeRequest.fromJson(Map<String, dynamic> json) =>
      RechargeRequest(
        transactionReference: json['transactionReference'],
        paymentMethod: json['paymentMethod'],
        amount: json['amount'],
        typeRechargeId: json['typeRechargeId'],
        rechargeDate: json['rechargeDate'] != null
            ? DateTime.parse(json['rechargeDate'])
            : null,
      );
}
