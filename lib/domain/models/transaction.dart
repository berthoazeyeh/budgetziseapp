class Transaction {
  final int id;
  final double amount;
  final DateTime date;
  final String? description;
  final String paymentMethod;
  final String? transactionReference;
  final String currency;
  final String transactionType;
  final String categoryName;
  final int userId;
  final String? receiptUrl;
  final String? place;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.paymentMethod,
    required this.transactionReference,
    required this.currency,
    required this.transactionType,
    required this.categoryName,
    required this.userId,
    required this.receiptUrl,
    required this.place,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    amount: double.parse(json['amount'].toString()),
    date: json['date'] != null
        ? DateTime.parse(json['date']).toLocal()
        : DateTime.now().toLocal(),
    description: json['description'],
    paymentMethod: json['paymentMethod'],
    transactionReference: json['transactionReference'],
    currency: json['currency'],
    transactionType: json['transactionType'],
    categoryName: json['categoryName'] ?? "",
    userId: json['userId'],
    receiptUrl: json['receiptUrl'],
    place: json['place'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'date': date.toUtc().toIso8601String(),
    'description': description,
    'paymentMethod': paymentMethod,
    'transactionReference': transactionReference,
    'currency': currency,
    'transactionType': transactionType,
    'categoryName': categoryName,
    'userId': userId,
    'receiptUrl': receiptUrl,
    'place': place,
  };
}
