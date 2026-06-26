import 'package:flutter/material.dart';

/// App color definitions
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF6200EE);
  static const Color primaryDark = Color(0xFF3700B3);
  static const Color primaryLight = Color(0xFFBB86FC);

  // Secondary Colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryDark = Color(0xFF018786);
  static const Color secondaryLight = Color(0xFF66FFF9);

  // Accent Colors
  static const Color accent = Color(0xFFFF6B6B);
  static const Color accentDark = Color(0xFFE63946);
  static const Color accentLight = Color(0xFFFFB3BA);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);

  // Error & Success Colors
  static const Color error = Color(0xFFB00020);
  static const Color errorDark = Color(0xFFCF6679);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Brand Colors (from designs)
  static const Color brandRed = Color(0xFFCF2027); // Secondary/Red from designs
  static const Color lightBlack = Color(0xFF303030); // Light black from designs
  static const Color promotionGreen = Color(0xFF00B545); // Promotion CTA green
  static const Color brandBlue = Color(0xFF0077B6); // Misc favorites accent
  static const Color dashboardPink = Color(0xFFFF467E);
  static const Color dashboardOrange = Color(0xFFFF9557);
  static const Color dashboardHighlightYellow = Color(0xFFFFCE00);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);

  // Divider Colors
  static const Color divider = Color(0xFFBDBDBD);
  static const Color dividerDark = Color(0xFF616161);

  // Social Create/Camera Screen Colors
  static const Color cameraBackground = Color(0xFF111111);
  static const Color cameraSemiTransparentWhite = Color(0x33FFFFFF); // #FFFFFF20
  static const Color cameraSemiTransparentWhite23 = Color(0x3BFFFFFF); // rgba(255,255,255,0.23)
  static const Color cameraRecordGradientStart = Color(0xFFFF6B6B); // Coral
  static const Color cameraRecordGradientEnd = Color(0xFFFF8A80); // Pink
  static const Color cameraGridLine = Color(0x80FFFFFF); // White with 0.5 opacity
  static const Color cameraModeSelected = Color(0xD4696969); // rgba(105,105,105,0.83)
  static const Color cameraModeUnselected = Color(0xFF2A2623);
  static const Color cameraMusicPillBg = Color(0xDB2A2623); // rgba(42,38,35,0.86)
}
