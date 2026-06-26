import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatingConstants {
  DatingConstants._();

  static const double cardBorderRadius = 28;
  static const double sectionCardRadius = 24;
  static const double buttonSize = 44;
  static const double smallButtonSize = 36;
  static const double roseButtonSize = 52;

  static BorderRadius get cardRadius =>
      BorderRadius.circular(cardBorderRadius.r);

  static BorderRadius get sectionRadius =>
      BorderRadius.circular(sectionCardRadius.r);

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0x14000000),
          blurRadius: 12.r,
          offset: Offset(0, 4.h),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0x1A000000),
          blurRadius: 20.r,
          offset: Offset(0, 8.h),
        ),
      ];

  static List<BoxShadow> get roseGlow => [
        BoxShadow(
          color: const Color(0x40E94057),
          blurRadius: 16.r,
          spreadRadius: 2.r,
        ),
      ];
}
