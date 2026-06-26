import 'package:flutter/foundation.dart';

/// Logger utility for app-wide logging
class AppLogger {
  AppLogger._();

  static void log(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag] ' : '';
      debugPrint('$tagStr$message');
    }
  }

  static void logError(
    dynamic error, {
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag] ERROR: ' : 'ERROR: ';
      debugPrint('$tagStr$error');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }
  }

  static void logInfo(String message, {String? tag}) {
    log('INFO: $message', tag: tag);
  }

  static void logWarning(String message, {String? tag}) {
    log('WARNING: $message', tag: tag);
  }
}

