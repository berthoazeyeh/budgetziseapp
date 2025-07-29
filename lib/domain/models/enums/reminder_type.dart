enum ReminderType {
  progress('PROGRESS'),
  deadline('DEADLINE'),
  contribution('CONTRIBUTION');

  final String value;
  const ReminderType(this.value);

  factory ReminderType.fromString(String value) {
    return ReminderType.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => ReminderType.progress,
    );
  }

  String toJson() => value;
}
