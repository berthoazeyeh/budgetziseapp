import 'package:budget_zise/domain/models/enums/goal_priority.dart';

class UpdateGoalRequest {
  final String title;
  final double targetAmount;
  final DateTime targetDate;
  final GoalPriority priority;
  final String? description;

  UpdateGoalRequest({
    required this.title,
    required this.targetAmount,
    required this.targetDate,
    this.priority = GoalPriority.medium,
    this.description,
  });

  factory UpdateGoalRequest.fromJson(Map<String, dynamic> json) {
    return UpdateGoalRequest(
      title: json['title'] ?? '',
      targetAmount: (json['targetAmount'] as num).toDouble(),
      targetDate: DateTime.parse(json['targetDate']),
      priority: GoalPriority.fromString(json['priority'] ?? 'medium'),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'targetAmount': targetAmount,
      'targetDate': targetDate.toIso8601String(),
      'priority': priority.toJson(),
      'description': description,
    };
  }
}
