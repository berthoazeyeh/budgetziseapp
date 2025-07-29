class NotificationType {
  final int id;
  final String typeName;
  final String icon;
  final String colorClass;
  final String description;
  final DateTime createdAt;

  NotificationType({
    required this.id,
    required this.typeName,
    required this.icon,
    required this.colorClass,
    this.description = '',
    required this.createdAt,
  });

  factory NotificationType.fromJson(Map<String, dynamic> json) {
    return NotificationType(
      id: json['id'] as int,
      typeName: json['typeName'] ?? '',
      icon: json['icon'] ?? '',
      colorClass: json['colorClass'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'typeName': typeName,
      'icon': icon,
      'colorClass': colorClass,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  NotificationType copyWith({
    int? id,
    String? typeName,
    String? icon,
    String? colorClass,
    String? description,
    DateTime? createdAt,
  }) {
    return NotificationType(
      id: id ?? this.id,
      typeName: typeName ?? this.typeName,
      icon: icon ?? this.icon,
      colorClass: colorClass ?? this.colorClass,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
