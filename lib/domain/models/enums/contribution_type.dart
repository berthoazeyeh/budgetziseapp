enum ContributionType {
  manual('MANUAL'),
  autoTransfer('AUTO_TRANSFER'),
  transactionLink('TRANSACTION_LINK');

  final String value;
  const ContributionType(this.value);

  factory ContributionType.fromString(String value) {
    return ContributionType.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => ContributionType.manual,
    );
  }

  String toJson() => value;
}
