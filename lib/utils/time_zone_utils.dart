// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import '../../../core/logger.dart';

class TimeZoneUtils {
  TimeZoneUtils._(); // private constructor

  /// Returns device timezone like "Asia/Kolkata"
  static Future<String> getLocalTimeZone() async {
    try {
      final TimezoneInfo timeZone = await FlutterTimezone.getLocalTimezone();
      logger.i("timeZone: $timeZone");
      return timeZone.identifier;
    } catch (e) {
      // fallback if something goes wrong
      return DateTime.now().timeZoneName;
    }
  }
}
