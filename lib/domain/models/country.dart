import 'package:budget_zise/domain/models/Continent.dart';
import 'package:budget_zise/domain/models/country_state.dart';
import 'package:budget_zise/domain/models/language.dart';
import 'package:budget_zise/domain/models/subdivision.dart';

class Country {
  final String code;
  final String awsRegion;
  final String capital;
  final String emoji;
  final String emojiU;
  final String native;
  final String phone;
  final List<String> phones;
  final List<String> currencies;
  final String currency;
  final String name;
  final Continent? continent;
  final String continentCode;
  final List<Language> languages;
  final List<CountryState> states;
  final List<Subdivision> subdivisions;

  Country({
    required this.code,
    required this.awsRegion,
    required this.capital,
    required this.emoji,
    required this.emojiU,
    required this.native,
    required this.phone,
    required this.phones,
    required this.currencies,
    required this.currency,
    required this.name,
    required this.continent,
    required this.continentCode,
    required this.languages,
    required this.states,
    required this.subdivisions,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    code: json['code'] ?? '',
    awsRegion: json['awsRegion'] ?? '',
    capital: json['capital'] ?? '',
    emoji: json['emoji'] ?? '',
    emojiU: json['emojiU'] ?? '',
    native: json['native'] ?? '',
    phone: json['phone'] ?? '',
    phones: List<String>.from(json['phones'] ?? []),
    currencies: List<String>.from(json['currencies'] ?? []),
    currency: json['currency'] ?? '',
    name: json['name'] ?? '',
    continent: json['continent'] != null
        ? Continent.fromJson(json['continent'])
        : null,
    continentCode: json['continentCode'] ?? '',
    languages: (json['languages'] as List<dynamic>? ?? [])
        .map((e) => Language.fromJson(e))
        .toList(),
    states: (json['states'] as List<dynamic>? ?? [])
        .map((e) => CountryState.fromJson(e))
        .toList(),
    subdivisions: (json['subdivisions'] as List<dynamic>? ?? [])
        .map((e) => Subdivision.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'code': code,
    'awsRegion': awsRegion,
    'capital': capital,
    'emoji': emoji,
    'emojiU': emojiU,
    'native': native,
    'phone': phone,
    'phones': phones,
    'currencies': currencies,
    'currency': currency,
    'name': name,
    'continent': continent?.toJson(),
    'continentCode': continentCode,
    'languages': languages.map((e) => e.toJson()).toList(),
    'states': states.map((e) => e.toJson()).toList(),
    'subdivisions': subdivisions.map((e) => e.toJson()).toList(),
  };
}
