import 'package:budget_zise/app_widget.dart';
import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/core/network/dio_client.dart';
import 'package:budget_zise/data/services/device_info_service.dart';
import 'package:budget_zise/data/services/notification_service.dart';
import 'package:budget_zise/firebase_options.dart';
import 'package:budget_zise/init_application.dart';
import 'package:budget_zise/data/services/local_storage_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.showNotification(
    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title: message.data['title'] ?? 'Notification',
    body: message.data['body'] ?? 'No body',
    payload: message.data['type'],
  );
}

void main() async {
  await InitApplication.initMyApplication();
  await EasyLocalization.ensureInitialized();
  await DeviceInfoService.instance.getDeviceId();
  await DeviceInfoService.instance.getDeviceInfo();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final logger = Logger();
  final localStorageService = LocalStorageService();

  final dio = await MyDio.create(logger, localStorageService);
  runApp(AppWidget(dio: dio));
}
