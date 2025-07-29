class SavingsStatisticsDto {
  final int totalGoals;
  final int activeGoals;
  final int completedGoals;
  final double totalSaved;
  final double totalTarget;
  final double avgProgressPercentage;

  SavingsStatisticsDto({
    required this.totalGoals,
    required this.activeGoals,
    required this.completedGoals,
    required this.totalSaved,
    required this.totalTarget,
    required this.avgProgressPercentage,
  });

  factory SavingsStatisticsDto.fromJson(Map<String, dynamic> json) {
    return SavingsStatisticsDto(
      totalGoals: json['totalGoals'],
      activeGoals: json['activeGoals'],
      completedGoals: json['completedGoals'],
      totalSaved: (json['totalSaved'] as num).toDouble(),
      totalTarget: (json['totalTarget'] as num).toDouble(),
      avgProgressPercentage: (json['avgProgressPercentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalGoals': totalGoals,
      'activeGoals': activeGoals,
      'completedGoals': completedGoals,
      'totalSaved': totalSaved,
      'totalTarget': totalTarget,
      'avgProgressPercentage': avgProgressPercentage,
    };
  }
}
