import 'package:budget_zise/domain/models/enums/goal_priority.dart';

class CreateGoalRequest {
  final String title;
  final double targetAmount;
  final int categoryId;
  final DateTime targetDate;
  final GoalPriority priority;
  final String? description;

  CreateGoalRequest({
    required this.title,
    required this.targetAmount,
    required this.categoryId,
    required this.targetDate,
    this.priority = GoalPriority.medium,
    this.description,
  });

  factory CreateGoalRequest.fromJson(Map<String, dynamic> json) {
    return CreateGoalRequest(
      title: json['title'] ?? '',
      targetAmount: (json['targetAmount'] as num).toDouble(),
      categoryId: json['categoryId'],
      targetDate: DateTime.parse(json['targetDate']),
      priority: GoalPriority.fromString(json['priority'] ?? 'medium'),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'targetAmount': targetAmount,
      'categoryId': categoryId,
      'targetDate': targetDate.toIso8601String(),
      'priority': priority.name,
      'description': description,
    };
  }
}
