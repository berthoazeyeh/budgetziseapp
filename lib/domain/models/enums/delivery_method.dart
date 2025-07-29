enum DeliveryMethod {
  app('APP'),
  email('EMAIL'),
  sms('SMS'),
  push('PUSH');

  final String value;
  const DeliveryMethod(this.value);

  factory DeliveryMethod.fromString(String value) {
    return DeliveryMethod.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => DeliveryMethod.app,
    );
  }

  String toJson() => value;
}
