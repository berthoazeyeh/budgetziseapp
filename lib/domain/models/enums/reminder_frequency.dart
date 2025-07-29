enum ReminderFrequency {
  daily('DAILY'),
  weekly('WEEKLY'),
  monthly('MONTHLY');

  final String value;
  const ReminderFrequency(this.value);

  factory ReminderFrequency.fromString(String value) {
    return ReminderFrequency.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => ReminderFrequency.monthly,
    );
  }

  String toJson() => value;
}
