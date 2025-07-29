enum NotificationPriority {
  low('LOW'),
  medium('MEDIUM'),
  high('HIGH');

  final String value;
  const NotificationPriority(this.value);

  factory NotificationPriority.fromString(String value) {
    return NotificationPriority.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => NotificationPriority.low,
    );
  }

  String toJson() => value;
}
