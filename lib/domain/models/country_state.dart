class CountryState {
  final int id;
  final String code;
  final String name;
  final String country;
  final String countryCode;

  CountryState({
    required this.id,
    required this.code,
    required this.name,
    required this.country,
    required this.countryCode,
  });

  factory CountryState.fromJson(Map<String, dynamic> json) => CountryState(
    id: json['id'] ?? 0,
    code: json['code'] ?? '',
    name: json['name'] ?? '',
    country: json['country'] ?? '',
    countryCode: json['countryCode'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'country': country,
    'countryCode': countryCode,
  };
}
