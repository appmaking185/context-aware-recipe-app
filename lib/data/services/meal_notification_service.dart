import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ivtexsolutionsapp/data/services/app_permissions_service.dart';
import 'package:ivtexsolutionsapp/utils/local_notification.dart';
import 'package:ivtexsolutionsapp/utils/time_zone_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MealNotificationResult {
  final bool permissionDenied;
  final String? errorMessage;

  const MealNotificationResult({
    required this.permissionDenied,
    this.errorMessage,
  });
}

class MealNotificationService {
  static const _breakfastId = 201;
  static const _lunchId = 202;
  static const _dinnerId = 203;

  static const _testId = 299;
  static const _testBreakfastId = 401;
  static const _testLunchId = 402;
  static const _testDinnerId = 403;

  // =========================
  // DAILY MEAL SCHEDULE
  // =========================
  Future<MealNotificationResult> scheduleDailyMealNotifications({
    String? breakfastSuggestion,
    String? lunchSuggestion,
    String? dinnerSuggestion,
  }) async {
    final granted = await AppPermissionsService.requestNotificationPermission();
    if (!granted) {
      return const MealNotificationResult(permissionDenied: true);
    }

    try {
      tz.initializeTimeZones();
      final zoneName = await TimeZoneUtils.getLocalTimeZone();
      tz.setLocalLocation(tz.getLocation(zoneName));

      await _cancelMealSchedules();

      // Breakfast - 8:00 AM
      await _scheduleMeal(
        id: _breakfastId,
        hour: 8,
        minute: 0,
        title: 'Breakfast Time',
        body: breakfastSuggestion ?? 'Try a fresh breakfast recipe 🍳',
      );

      // Lunch - 2:00 PM
      await _scheduleMeal(
        id: _lunchId,
        hour: 14,
        minute: 0,
        title: 'Lunch Suggestion',
        body: lunchSuggestion ?? 'Discover a tasty lunch recipe 🍛',
      );

      // Dinner - 8:00 PM
      await _scheduleMeal(
        id: _dinnerId,
        hour: 20,
        minute: 0,
        title: 'Dinner Ideas',
        body: dinnerSuggestion ?? 'Pick a comforting dinner recipe 🌙',
      );

      return const MealNotificationResult(permissionDenied: false);
    } catch (e) {
      return MealNotificationResult(
        permissionDenied: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Ensures daily meal notifications exist even if API never loads.
  /// Call this on app startup. If already scheduled, it does nothing.
  Future<MealNotificationResult> ensureDailyMealNotificationsScheduled() async {
    final pending = await flutterLocalNotificationsPlugin
        .pendingNotificationRequests();
    final ids = pending.map((e) => e.id).toSet();

    final alreadyScheduled =
        ids.contains(_breakfastId) &&
        ids.contains(_lunchId) &&
        ids.contains(_dinnerId);

    if (alreadyScheduled) {
      // ignore: avoid_print
      print('[MealNotification] daily schedule already present');
      return const MealNotificationResult(permissionDenied: false);
    }

    return scheduleDailyMealNotifications();
  }

  // =========================
  // CORE SCHEDULER
  // =========================
  Future<void> _scheduleMeal({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstance(hour, minute),
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'meal_notification',
    );
  }

  Future<void> _cancelMealSchedules() async {
    await flutterLocalNotificationsPlugin.cancel(id: _breakfastId);
    await flutterLocalNotificationsPlugin.cancel(id: _lunchId);
    await flutterLocalNotificationsPlugin.cancel(id: _dinnerId);
  }

  // =========================
  // TEST NOTIFICATION (IMMEDIATE)
  // =========================
  Future<void> sendTestNotificationNow() async {
    await flutterLocalNotificationsPlugin.show(
      id: _testId,
      title: 'Test Recipe Notification',
      body: 'This is a test notification from recipe app.',
      notificationDetails: platformChannelSpecifics,
      payload: 'recipe_test',
    );
  }

  // =========================
  // QUICK TEST (10s / 20s / 30s)
  // =========================
  Future<MealNotificationResult> scheduleQuickMealTestNotifications() async {
    final granted = await AppPermissionsService.requestNotificationPermission();
    if (!granted) {
      return const MealNotificationResult(permissionDenied: true);
    }

    try {
      tz.initializeTimeZones();
      final zoneName = await TimeZoneUtils.getLocalTimeZone();
      tz.setLocalLocation(tz.getLocation(zoneName));

      final now = tz.TZDateTime.now(tz.local);

      await _scheduleTest(
        _testBreakfastId,
        now.add(const Duration(seconds: 10)),
        'Breakfast Test',
      );

      await _scheduleTest(
        _testLunchId,
        now.add(const Duration(seconds: 20)),
        'Lunch Test',
      );

      await _scheduleTest(
        _testDinnerId,
        now.add(const Duration(seconds: 30)),
        'Dinner Test',
      );

      final pending = await flutterLocalNotificationsPlugin
          .pendingNotificationRequests();

      debugPrint('[MealNotification] pending=${pending.length}');

      return const MealNotificationResult(permissionDenied: false);
    } catch (e) {
      return MealNotificationResult(
        permissionDenied: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _scheduleTest(int id, tz.TZDateTime time, String title) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: 'Quick test notification',
      scheduledDate: time,
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  // =========================
  // DIAGNOSTICS
  // =========================
  Future<String> diagnoseNotificationState() async {
    final status = await Permission.notification.status;

    final androidImpl = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final enabled = await androidImpl?.areNotificationsEnabled();

    final pending = await flutterLocalNotificationsPlugin
        .pendingNotificationRequests();

    final msg =
        'perm=${status.name}, enabled=$enabled, pending=${pending.length}';

    debugPrint('[MealNotification] diagnose: $msg');
    return msg;
  }

  // =========================
  // TIME HELPERS
  // =========================
  tz.TZDateTime _nextInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
