class Language {
  final String code;
  final String name;
  final String native;
  final bool rtl;

  Language({
    required this.code,
    required this.name,
    required this.native,
    required this.rtl,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    code: json['code'] ?? '',
    name: json['name'] ?? '',
    native: json['native'] ?? '',
    rtl: json['rtl'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'native': native,
    'rtl': rtl,
  };
}
