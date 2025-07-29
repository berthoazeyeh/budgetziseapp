import 'package:budget_zise/budget_zise.dart'
    show HydratedCubit, BuildContextEasyLocalizationExtension;
import 'package:flutter/material.dart'
    show Locale, WidgetsBinding, BuildContext;

class LanguageSwitchCubit extends HydratedCubit<Locale> {
  LanguageSwitchCubit() : super(_getSystemLocale());

  // Récupérer la langue du système
  static Locale _getSystemLocale() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    return Locale(systemLocale.languageCode);
  }

  Locale get currentLocale => state;
  bool get isEnglish => state.languageCode == "en";
  bool get isFrench => state.languageCode == "fr";

  // Changer de langue
  void switchLanguage(BuildContext context, String languageCode) {
    context.setLocale(Locale(languageCode));
    emit(Locale(languageCode));
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    return Locale(json['languageCode'] ?? 'en');
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    return {'languageCode': state.languageCode};
  }
}
