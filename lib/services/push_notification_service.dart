import 'dart:io';

import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

/// Displays push notifications while the app is in the FOREGROUND.
///
/// Background/terminated notifications are shown by the OS automatically. In
/// the foreground, Android does NOT show them — we listen to
/// [FirebaseMessaging.onMessage] and render a local heads-up notification.
/// iOS shows them itself via [setForegroundNotificationPresentationOptions].
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Notifications',
    description: 'Used for important Business Bosses notifications.',
    importance: Importance.high,
  );

  bool _initialized = false;

  /// Call once during app start, after Firebase is initialized.
  Future<void> init() async {
    if (_initialized) return;

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // Permissions are requested separately via FirebaseMessaging.
    const DarwinInitializationSettings darwinInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      settings:
          const InitializationSettings(android: androidInit, iOS: darwinInit),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _routeFromTitle(response.payload);
      },
    );

    // Create the Android channel the foreground notifications post to.
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Let iOS present alerts/badges/sounds while the app is in the foreground.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Start listening for foreground messages.
    FirebaseMessaging.onMessage.listen(showFromMessage);

    _initialized = true;
  }

  /// Renders a foreground FCM message as a local notification (Android only —
  /// iOS already presents it via the presentation options above).
  Future<void> showFromMessage(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    if (notification == null || !Platform.isAndroid) return;

    try {
      await _plugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        // Mirror the data the OS-tap handler uses so taps route the same way.
        payload: notification.title,
      );
    } catch (e) {
      debugPrint('PushNotificationService.showFromMessage failed: $e');
    }
  }

  /// Mirrors the routing in main._handleMessageOpenedApp so tapping a
  /// foreground notification lands on the same screen.
  void _routeFromTitle(String? title) {
    final String t = (title ?? '').toLowerCase();
    if (t.contains('new message')) {
      Get.toNamed(Routes.chat);
    } else {
      Get.toNamed(Routes.notifications);
    }
  }
}
