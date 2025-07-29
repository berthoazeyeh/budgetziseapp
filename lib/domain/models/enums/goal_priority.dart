enum GoalPriority {
  low('LOW'),
  medium('MEDIUM'),
  high('HIGH');

  final String value;
  const GoalPriority(this.value);

  factory GoalPriority.fromString(String value) {
    return GoalPriority.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => GoalPriority.medium,
    );
  }

  String toJson() => value;
}
