import 'package:budget_zise/domain/models/enums/delivery_method.dart';
import 'package:budget_zise/domain/models/user_model.dart';
import 'package:budget_zise/domain/models/notification_type.dart';

class NotificationPreference {
  final int id;
  final int userId;
  final int notificationTypeId;
  final bool isEnabled;
  final DeliveryMethod deliveryMethod;
  final DateTime createdAt;
  final DateTime updatedAt;

  final UserModel? user;
  final NotificationType? notificationType;

  NotificationPreference({
    required this.id,
    required this.userId,
    required this.notificationTypeId,
    this.isEnabled = true,
    this.deliveryMethod = DeliveryMethod.app,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.notificationType,
  });

  factory NotificationPreference.fromJson(Map<String, dynamic> json) {
    return NotificationPreference(
      id: json['id'] as int,
      userId: json['userId'] as int,
      notificationTypeId: json['notificationTypeId'] as int,
      isEnabled: json['isEnabled'] as bool? ?? true,
      deliveryMethod: DeliveryMethod.fromString(json['deliveryMethod']),
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      notificationType: json['notificationType'] != null
          ? NotificationType.fromJson(json['notificationType'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'notificationTypeId': notificationTypeId,
      'isEnabled': isEnabled,
      'deliveryMethod': deliveryMethod.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user': user?.toJson(),
      'notificationType': notificationType?.toJson(),
    };
  }

  NotificationPreference copyWith({
    int? id,
    int? userId,
    int? notificationTypeId,
    bool? isEnabled,
    DeliveryMethod? deliveryMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? user,
    NotificationType? notificationType,
  }) {
    return NotificationPreference(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      notificationTypeId: notificationTypeId ?? this.notificationTypeId,
      isEnabled: isEnabled ?? this.isEnabled,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      notificationType: notificationType ?? this.notificationType,
    );
  }
}
