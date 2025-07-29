class PlatformStats {
  final double averageReview;
  final double totalRecharges;
  final int totalUsers;
  final String currency;
  final double availability;

  const PlatformStats({
    required this.averageReview,
    required this.totalRecharges,
    required this.totalUsers,
    this.currency = 'CFA',
    this.availability = 99.9,
  });

  // Méthode pour convertir depuis un JSON
  factory PlatformStats.fromJson(Map<String, dynamic> json) {
    return PlatformStats(
      averageReview: (json['averageReview'] as num).toDouble(),
      totalRecharges: (json['totalRecharges'] as num).toDouble(),
      totalUsers: json['totalUsers'],
      currency: json['currency'] ?? 'CFA',
      availability: (json['availability'] ?? 99.9) as double,
    );
  }

  // Méthode pour convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'averageReview': averageReview,
      'totalRecharges': totalRecharges,
      'totalUsers': totalUsers,
      'currency': currency,
      'availability': availability,
    };
  }
}
