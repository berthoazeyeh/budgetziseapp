import 'package:budget_zise/data/services/notification_service.dart';
import 'package:budget_zise/presentation/cubits/notification_count_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getFcmToken() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    return token;
  }

  Future<void> init(NotificationCountCubit notificationCountCubit) async {
    // 🔑 Demander la permission (iOS)
    await _firebaseMessaging.requestPermission();

    // 🔑 Obtenir le FCM Token
    final token = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $token");
    // → Stocke ce token dans ta base de données utilisateur

    // 🔔 Ecoute des notifications (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        NotificationService.showNotification(
          id: message.notification.hashCode,
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
        );
        notificationCountCubit.fetchNotificationCount();
      }
      debugPrint('Notification reçue: ${message.notification?.title}');
      // → Affiche une notification locale ici si besoin
    });

    // 🔔 Quand l’app est ouverte par une notif
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification ouverte: ${message.data}');
      // → Redirige vers une page spécifique
    });

    // 🔔 Quand l’app est lancée par une notif (froid)
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      debugPrint('Notification reçue au lancement: ${initialMessage.data}');
    }
  }
}
