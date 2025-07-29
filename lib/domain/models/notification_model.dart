import 'package:budget_zise/domain/models/enums/notification_priority.dart';
import 'package:budget_zise/domain/models/enums/related_entity_type.dart';

class NotificationModel {
  final int id;
  final int userId;
  final String title;
  final String message;
  final bool isRead;
  final NotificationPriority priority;
  final RelatedEntityType? relatedEntityType;
  final int? relatedEntityId;
  final String metadata;
  final DateTime createdAt;
  final DateTime? readAt;
  final String typeName;
  final String icon;
  final String colorClass;
  final String timeCategory;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.priority,
    this.relatedEntityType,
    this.relatedEntityId,
    required this.metadata,
    required this.createdAt,
    this.readAt,
    required this.typeName,
    required this.icon,
    required this.colorClass,
    required this.timeCategory,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isRead: json['isRead'] ?? false,
      priority: NotificationPriority.fromString(json['priority']),
      relatedEntityType: json['relatedEntityType'] != null
          ? RelatedEntityType.fromString(json['relatedEntityType'])
          : null,
      relatedEntityId: json['relatedEntityId'],
      metadata: json['metadata'] ?? '',
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt']).toLocal()
          : null,
      typeName: json['typeName'] ?? '',
      icon: json['icon'] ?? '',
      colorClass: json['colorClass'] ?? '',
      timeCategory: json['timeCategory'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'isRead': isRead,
      'priority': priority.toJson(),
      'relatedEntityType': relatedEntityType?.toJson(),
      'relatedEntityId': relatedEntityId,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'typeName': typeName,
      'icon': icon,
      'colorClass': colorClass,
      'timeCategory': timeCategory,
    };
  }
}
