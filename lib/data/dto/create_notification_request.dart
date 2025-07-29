import 'package:budget_zise/domain/models/enums/related_entity_type.dart';

class CreateNotificationRequest {
  final String notificationTypeName;
  final String title;
  final String message;
  final RelatedEntityType? relatedEntityType;
  final int? relatedEntityId;
  final String? metadata;

  CreateNotificationRequest({
    required this.notificationTypeName,
    required this.title,
    required this.message,
    this.relatedEntityType,
    this.relatedEntityId,
    this.metadata,
  });

  factory CreateNotificationRequest.fromJson(Map<String, dynamic> json) {
    return CreateNotificationRequest(
      notificationTypeName: json['notificationTypeName'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      relatedEntityType: json['relatedEntityType'] != null
          ? RelatedEntityType.fromString(json['relatedEntityType'])
          : null,
      relatedEntityId: json['relatedEntityId'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationTypeName': notificationTypeName,
      'title': title,
      'message': message,
      'relatedEntityType': relatedEntityType?.toJson(),
      'relatedEntityId': relatedEntityId,
      'metadata': metadata,
    };
  }
}
