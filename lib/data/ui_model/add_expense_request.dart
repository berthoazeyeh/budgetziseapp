class AddExpenseRequest {
  final double amount;
  final int categeryId;
  final String description;
  final String paymentMethod;
  final String? receiptUrl;
  final String? place;

  AddExpenseRequest({
    required this.amount,
    required this.categeryId,
    required this.description,
    required this.paymentMethod,
    this.receiptUrl,
    this.place,
  });

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'categeryId': categeryId,
    'description': description,
    'paymentMethod': paymentMethod,
    'receiptUrl': receiptUrl,
    'place': place,
  };
}
