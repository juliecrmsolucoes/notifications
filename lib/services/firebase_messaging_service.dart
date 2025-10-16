import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:notifications/services/local_notifications_service.dart';

class FirebaseMessagingService {
  // Private constructor for singleton pattern
  FirebaseMessagingService._internal();

  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  factory FirebaseMessagingService.instance() => _instance;

  LocalNotificationsService? _localNotificationsService;

  Future<void> init({
    required LocalNotificationsService localNotificationService,
  }) async {
    _localNotificationsService = localNotificationService;

    await _requestPermission();

    await _handlePushNotificationsToken();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  Future<void> _handlePushNotificationsToken() async {
    final token = Platform.isAndroid
        ? await FirebaseMessaging.instance.getToken()
        : await FirebaseMessaging.instance.getAPNSToken();
    log("📲 Token FCM atual: $token");

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      if (kDebugMode) {
        log("📱🔃 Token FCM refreshed: $token");
        //optionally send token to your server for targeting this device
      }
    });
  }

  /// Requests notification permission from the user
  Future<void> _requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Handles messages received while the app is in the foreground
  void _onForegroundMessage(RemoteMessage message) {
    print('Foreground message received: ${message.data.toString()}');
    final notificationData = message.notification;
    if (notificationData != null) {
      // Display a local notification using the service
      _localNotificationsService?.showNotification(
        notificationData.title,
        notificationData.body,
        message.data.toString(),
      );
    }
  }

  /// Handles notification taps when app is opened from the background or terminated state
  void _onMessageOpenedApp(RemoteMessage message) {
    print('Notification caused the app to open: ${message.data.toString()}');
    // TODO: Add navigation or specific handling based on message data
  }
}

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.data.toString()}');
}
