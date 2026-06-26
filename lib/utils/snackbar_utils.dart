import 'package:flutter/material.dart';

class SnackbarUtils {
  /// Show a SnackBar with custom message and color
  static void show(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.black87,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }

  /// Success SnackBar
  static void showSuccess(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.green);
  }

  /// Error SnackBar
  static void showError(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.red);
  }

  /// Warning / Info SnackBar
  static void showWarning(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.orange);
  }
}
