enum RelatedEntityType {
  budget('BUDGET'),
  goal('GOAL'),
  transaction('TRANSACTION'),
  report('REPORT');

  final String value;
  const RelatedEntityType(this.value);

  factory RelatedEntityType.fromString(String value) {
    return RelatedEntityType.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => RelatedEntityType.budget,
    );
  }

  String toJson() => value;
}
