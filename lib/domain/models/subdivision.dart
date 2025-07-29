class Subdivision {
  final String code;
  final String name;
  final String emoji;

  Subdivision({required this.code, required this.name, required this.emoji});

  factory Subdivision.fromJson(Map<String, dynamic> json) => Subdivision(
    code: json['code'] ?? '',
    name: json['name'] ?? '',
    emoji: json['emoji'] ?? '',
  );

  Map<String, dynamic> toJson() => {'code': code, 'name': name, 'emoji': emoji};
}
