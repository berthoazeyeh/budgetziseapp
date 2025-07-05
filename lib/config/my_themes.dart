import 'package:budget_zise/budget_zise.dart';
import 'package:flutter/material.dart';

import '../constants/my_colors.dart';

final class MyThemes {
  MyThemes._();

  static final lightTheme = ThemeData(
    primaryColor: MyColors.primary,
    colorScheme: const ColorScheme.light().copyWith(primary: MyColors.primary),
    scaffoldBackgroundColor: MyColors.white,
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        bodyLarge: TextStyle(color: MyColors.darkGray),
        bodyMedium: TextStyle(color: MyColors.darkGray),
        bodySmall: TextStyle(color: MyColors.darkGray),
      ),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: MyColors.white),
    datePickerTheme: const DatePickerThemeData(
      todayBorder: BorderSide(color: MyColors.primary),
      rangePickerSurfaceTintColor: MyColors.primary,
    ),
  );

  static final darkTheme = lightTheme.copyWith(
    colorScheme: const ColorScheme.dark().copyWith(primary: MyColors.primary),
    scaffoldBackgroundColor: MyColors.darkerGray,
  );

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
