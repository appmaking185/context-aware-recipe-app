import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dating_colors.dart';

class DatingTextStyles {
  DatingTextStyles._();

  static TextStyle get _base => GoogleFonts.inter();

  static String get interFontFamily =>
      GoogleFonts.inter().fontFamily ?? 'Inter';

  static TextStyle get dailyPill => _base.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: DatingColors.textPrimary,
        letterSpacing: -0.2,
      );

  static TextStyle get profileName => _base.copyWith(
        fontSize: 26.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: -0.5,
        height: 1.1,
      );

  static TextStyle get profileDetail => _base.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white.withValues(alpha: 0.95),
        height: 1.4,
      );

  static TextStyle get badgeText => _base.copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        letterSpacing: -0.1,
      );

  static TextStyle get badgeTextLight => _base.copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: DatingColors.textPrimary,
        letterSpacing: -0.1,
      );

  static TextStyle get sectionHeader => _base.copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: DatingColors.sectionHeader,
        letterSpacing: 1.2,
      );

  static TextStyle get aboutBody => _base.copyWith(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: DatingColors.textPrimary,
        height: 1.55,
        letterSpacing: -0.2,
      );

  static TextStyle get promptHeader => _base.copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: DatingColors.sectionHeader,
        letterSpacing: 0.8,
      );

  static TextStyle get promptBody => _base.copyWith(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: DatingColors.textPrimary,
        height: 1.35,
        letterSpacing: -0.4,
      );

  static TextStyle get basicsLabel => _base.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: DatingColors.textTertiary,
      );

  static TextStyle get basicsValue => _base.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: DatingColors.textPrimary,
      );

  static TextStyle get basicsSubValue => _base.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: DatingColors.textSecondary,
      );

  static TextStyle get dreamBody => _base.copyWith(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: DatingColors.textPrimary,
        height: 1.55,
      );

  static TextStyle get navLabel => _base.copyWith(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
      );

  static TextStyle get videoLabel => _base.copyWith(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      );

  static TextStyle get ambitionCaps => _base.copyWith(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: DatingColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get interestChip => _base.copyWith(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: DatingColors.textPrimary,
      );

  static TextStyle get datingGoalLabel => _base.copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 1.2,
      );

  static TextStyle get datingGoalTitle => _base.copyWith(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 1.3,
        letterSpacing: -0.3,
      );

  static TextStyle get datingGoalBody => _base.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white.withValues(alpha: 0.92),
        height: 1.5,
      );
}
