import 'package:budget_zise/budget_zise.dart' show HydratedCubit;
import 'package:flutter/foundation.dart' show PlatformDispatcher;
import 'package:flutter/material.dart' show ThemeMode, Brightness;

class ThemeSwitchCubit extends HydratedCubit<ThemeMode> {
  ThemeSwitchCubit() : super(ThemeMode.system);

  ThemeMode get themeMode => state;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = PlatformDispatcher.instance.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void switchTheme([bool? isOn]) {
    if (isOn != null) {
      emit(isOn ? ThemeMode.dark : ThemeMode.light);
    } else {
      emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    }
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values.firstWhere(
      (t) => t.name == json['name'],
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) => {'name': state.name};
}
