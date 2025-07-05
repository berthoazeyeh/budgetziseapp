import 'package:flutter/foundation.dart' show kReleaseMode;

final class MyStrings {
  MyStrings._();

  // ignore: dead_code
  static const isProductionMode = false && kReleaseMode;
  static const String baseUrl = "https://budgetandrens.onrender.com";
}
