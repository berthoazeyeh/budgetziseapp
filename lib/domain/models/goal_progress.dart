import 'package:budget_zise/domain/models/enums/goal_priority.dart';
import 'package:budget_zise/domain/models/enums/goal_status.dart';
import 'package:budget_zise/domain/models/enums/reminder_frequency.dart';

class GoalProgressModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final DateTime? targetDate;
  final GoalPriority priority;
  final GoalStatus status;
  final bool autoTransferEnabled;
  final double? autoTransferAmount;
  final ReminderFrequency? autoTransferFrequency;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final double progressPercentage;
  final double remainingAmount;
  final int? daysRemaining;
  final String statusCalculated;

  GoalProgressModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    this.targetDate,
    required this.priority,
    required this.status,
    required this.autoTransferEnabled,
    this.autoTransferAmount,
    this.autoTransferFrequency,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.progressPercentage,
    required this.remainingAmount,
    this.daysRemaining,
    required this.statusCalculated,
  });

  factory GoalProgressModel.fromJson(Map<String, dynamic> json) {
    return GoalProgressModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      targetDate: json['targetDate'] != null
          ? DateTime.parse(json['targetDate'])
          : null,
      priority: GoalPriority.values.byName(json['priority']),
      status: GoalStatus.values.byName(json['status']),
      autoTransferEnabled: json['autoTransferEnabled'] ?? false,
      autoTransferAmount: json['autoTransferAmount'] != null
          ? (json['autoTransferAmount'] as num).toDouble()
          : null,
      autoTransferFrequency: json['autoTransferFrequency'] != null
          ? ReminderFrequency.values.byName(json['autoTransferFrequency'])
          : null,
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt']).toLocal()
          : null,
      categoryName: json['categoryName'] ?? '',
      categoryIcon: json['categoryIcon'] ?? '',
      categoryColor: json['categoryColor'] ?? '',
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      daysRemaining: json['daysRemaining'],
      statusCalculated: json['statusCalculated'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate?.toIso8601String(),
      'priority': priority.toJson(),
      'status': status.toJson(),
      'autoTransferEnabled': autoTransferEnabled,
      'autoTransferAmount': autoTransferAmount,
      'autoTransferFrequency': autoTransferFrequency?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'categoryColor': categoryColor,
      'progressPercentage': progressPercentage,
      'remainingAmount': remainingAmount,
      'daysRemaining': daysRemaining,
      'statusCalculated': statusCalculated,
    };
  }
}
