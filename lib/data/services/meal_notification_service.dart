import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    final status = await Permission.notification.request();
    if (!status.isGranted) {
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
    final status = await Permission.notification.request();
    if (!status.isGranted) {
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

/*
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:unite_flutter/presentation/ui/basicWidget/common_time_zone.dart';
import 'package:unite_flutter/utils/local_notification.dart';



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

  Future<MealNotificationResult> scheduleDailyMealNotifications({
    String? breakfastSuggestion,
    String? lunchSuggestion,
    String? dinnerSuggestion,
  }) async {
    final status = await Permission.notification.request();
    if (!status.isGranted) {
      return const MealNotificationResult(permissionDenied: true);
    }

    try {
      tz.initializeTimeZones();
      final zoneName = await TimeZoneUtils.getLocalTimeZone();
      tz.setLocalLocation(tz.getLocation(zoneName));
      await _cancelMealSchedules();

      await _schedule(
        id: _breakfastId,
        hour: 9,
        minute: 14,
        title: 'Breakfast Time',
        body: breakfastSuggestion == null
            ? 'Try a fresh breakfast recipe now.'
            : 'Try $breakfastSuggestion',
      );
      await _schedule(
        id: _lunchId,
        hour: 14,
        minute: 0,
        title: 'Lunch Suggestion',
        body: lunchSuggestion == null
            ? 'Discover a tasty lunch recipe for your day.'
            : 'Lunch idea: $lunchSuggestion',
      );
      await _schedule(
        id: _dinnerId,
        hour: 20,
        minute: 0,
        title: 'Dinner Ideas',
        body: dinnerSuggestion == null
            ? 'Pick a comforting dinner recipe tonight.'
            : 'Dinner pick: $dinnerSuggestion',
      );

      return const MealNotificationResult(permissionDenied: false);
    } catch (e) {
      return MealNotificationResult(
        permissionDenied: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _cancelMealSchedules() async {
    await flutterLocalNotificationsPlugin.cancel(_breakfastId);
    await flutterLocalNotificationsPlugin.cancel(_lunchId);
    await flutterLocalNotificationsPlugin.cancel(_dinnerId);
  }

  // Future<void> _schedule({
  //   required int id,
  //   required int hour,
  //   required String title,
  //   required String body,
  // }) async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     id,
  //     title,
  //     body,
  //     _nextInstance(hour),
  //     platformChannelSpecifics,
  //     androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //     payload: 'recipe_suggestion',
  //   );
  // }
  Future<void> _schedule({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstance(hour, minute),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'recipe_suggestion',
    );
  }

  Future<void> sendTestNotificationNow() async {
    await flutterLocalNotificationsPlugin.show(
      _testId,
      'Test Recipe Notification',
      'This is a test notification from recipe app.',
      platformChannelSpecifics,
      payload: 'recipe_test',
    );
  }

  /// Quick QA helper: schedules 3 notifications in 10/20/30 seconds.
  /// Does NOT touch the daily repeating schedule.
  Future<MealNotificationResult> scheduleQuickMealTestNotifications() async {
    final status = await Permission.notification.request();
    if (!status.isGranted) {
      return const MealNotificationResult(permissionDenied: true);
    }

    try {
      tz.initializeTimeZones();
      final zoneName = await TimeZoneUtils.getLocalTimeZone();
      tz.setLocalLocation(tz.getLocation(zoneName));

      final now = tz.TZDateTime.now(tz.local);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        _testBreakfastId,
        'Breakfast Time (Test)',
        'Quick test: breakfast suggestion.',
        now.add(const Duration(seconds: 10)),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'recipe_test_breakfast',
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        _testLunchId,
        'Lunch Suggestion (Test)',
        'Quick test: lunch suggestion.',
        now.add(const Duration(seconds: 20)),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'recipe_test_lunch',
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        _testDinnerId,
        'Dinner Ideas (Test)',
        'Quick test: dinner suggestion.',
        now.add(const Duration(seconds: 30)),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'recipe_test_dinner',
      );

      final pending =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      // ignore: avoid_print
      print('[MealNotification] pending scheduled count=${pending.length}');

      return const MealNotificationResult(permissionDenied: false);
    } catch (e) {
      return MealNotificationResult(
        permissionDenied: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<String> diagnoseNotificationState() async {
    final status = await Permission.notification.status;
    final androidImpl =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final enabled = await androidImpl?.areNotificationsEnabled();
    final pending =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    final msg = [
      'perm=${status.name}',
      'enabled=${enabled ?? 'unknown'}',
      'pending=${pending.length}',
    ].join(', ');

    // ignore: avoid_print
    print('[MealNotification] diagnose: $msg');
    return msg;
  }

  tz.TZDateTime _nextInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
*/
