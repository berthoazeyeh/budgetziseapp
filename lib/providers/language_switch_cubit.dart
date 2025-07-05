import 'package:budget_zise/budget_zise.dart' show HydratedCubit;
import 'package:flutter/material.dart' show Locale, WidgetsBinding;

class LanguageSwitchCubit extends HydratedCubit<Locale> {
  LanguageSwitchCubit() : super(_getSystemLocale());

  // Récupérer la langue du système
  static Locale _getSystemLocale() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    return Locale(systemLocale.languageCode);
  }

  Locale get currentLocale => state;

  // Changer de langue
  void switchLanguage(String languageCode) {
    emit(Locale(languageCode));
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    return Locale('en');
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    return {'languageCode': state.languageCode};
  }
}
