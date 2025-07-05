import 'package:budget_zise/app_widget.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/network/dio_client.dart';
import 'package:budget_zise/init_application.dart';
import 'package:budget_zise/data/services/local_storage_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() async {
  await InitApplication.initMyApplication();
  await EasyLocalization.ensureInitialized();
  final logger = Logger();
  final localStorageService = LocalStorageService();

  final dio = await MyDio.create(logger, localStorageService);
  runApp(AppWidget(dio: dio));
}
