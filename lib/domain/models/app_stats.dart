class AppStats {
  final double averageReview;
  final double totalRecharges;
  final double totalUsers;
  final String currency;
  final double availability;

  AppStats({
    required this.averageReview,
    required this.totalRecharges,
    required this.totalUsers,
    required this.currency,
    required this.availability,
  });

  factory AppStats.fromJson(Map<String, dynamic> json) => AppStats(
    averageReview: json['averageReview'] ?? 0,
    totalRecharges: json['totalRecharges'] ?? 0,
    totalUsers: json['totalUsers'] ?? 0,
    currency: json['currency'] ?? '',
    availability: json['availability'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'averageReview': averageReview,
    'totalRecharges': totalRecharges,
    'totalUsers': totalUsers,
    'currency': currency,
    'availability': availability,
  };
}
