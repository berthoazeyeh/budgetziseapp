class Continent {
  final String code;
  final String name;

  Continent({required this.code, required this.name});

  factory Continent.fromJson(Map<String, dynamic> json) =>
      Continent(code: json['code'] ?? '', name: json['name'] ?? '');

  Map<String, dynamic> toJson() => {'code': code, 'name': name};
}
