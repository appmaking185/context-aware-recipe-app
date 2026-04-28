import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/logger.dart';

AndroidNotificationChannel mychannel = const AndroidNotificationChannel(
  'basic_channel',
  'Incoming notifications',
  importance: Importance.max,
  playSound: true,
  showBadge: true,
  enableLights: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final AndroidNotificationDetails _androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      mychannel.id,
      mychannel.name,
      icon: 'ic_stat_notification',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableLights: true,
    );

const DarwinNotificationDetails _iOSPlatformChannelSpecifics =
    DarwinNotificationDetails(
      threadIdentifier: 'thread_id',
      presentSound: true,
    );

final NotificationDetails platformChannelSpecifics = NotificationDetails(
  android: _androidPlatformChannelSpecifics,
  iOS: _iOSPlatformChannelSpecifics,
);

class LocalNotification {
  static LocalNotification localNotificationInstance = LocalNotification._();
  static Future<void>? _initFuture;

  LocalNotification._();

  static Future<void> ensureInitialized() {
    return _initFuture ??= localNotificationInstance
        ._createLocalNotificationsInstance();
  }

  Future<void> _createLocalNotificationsInstance() async {
    await _requestPlatformSpecificPermission();
    await _initializeAllNotificationSettings();
  }

  Future<void> _requestPlatformSpecificPermission() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else {
      try {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      } catch (e) {
        logger.e(e);
      }
    }

  }

  Future<void> _initializeAllNotificationSettings() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_notification');

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(mychannel);

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    /// ✅ FIXED HERE (IMPORTANT CHANGE)
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          logger.i('notification payload: ${response.payload}');
        }
      },

      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static void notificationTapBackground(NotificationResponse response) {
    logger.i("Background notification clicked: ${response.payload}");
  }
}
