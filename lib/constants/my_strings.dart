import 'package:flutter/foundation.dart' show kReleaseMode;

final class MyStrings {
  MyStrings._();

  // ignore: dead_code
  static const isProductionMode = false && kReleaseMode;
  static const String baseUrl = "https://budgetandrens.onrender.com";
  static const String graphQLUrl =
      "https://budgetandrens.onrender.com/graphql/";
  static const String graphQLWsUrl = "wss://budgetandrens.onrender.com/";

  static const String webUrl = 'https://budget-rens.vercel.app';
}
