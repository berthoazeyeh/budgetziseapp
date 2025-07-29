enum GoalStatus {
  active('ACTIVE'),
  completed('COMPLETED'),
  paused('PAUSED'),
  cancelled('CANCELLED');

  final String value;
  const GoalStatus(this.value);

  factory GoalStatus.fromString(String value) {
    return GoalStatus.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => GoalStatus.active,
    );
  }

  String toJson() => value;
}
