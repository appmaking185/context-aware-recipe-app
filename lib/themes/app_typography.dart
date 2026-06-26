import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// App typography definitions
/// All text styles use Poppins font family from Google Fonts
class AppTypography {
  AppTypography._();

  /// Poppins font family from Google Fonts
  static String get poppinsFontFamily =>
      GoogleFonts.poppins().fontFamily ?? 'Poppins';

  // Headings
  static TextStyle get h1 => GoogleFonts.poppins(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5.sp,
    height: 1.2,
  );

  static TextStyle get h2 => GoogleFonts.poppins(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5.sp,
    height: 1.3,
  );

  static TextStyle get h3 => GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  static TextStyle get h4 => GoogleFonts.poppins(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15.sp,
    height: 1.4,
  );

  static TextStyle get h5 => GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15.sp,
    height: 1.4,
  );

  static TextStyle get h6 => GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15.sp,
    height: 1.5,
  );

  // Body Text
  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5.sp,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25.sp,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4.sp,
    height: 1.5,
  );

  // Labels
  static TextStyle get labelLarge => GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1.sp,
    height: 1.4,
  );

  static TextStyle get labelMedium => GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5.sp,
    height: 1.4,
  );

  static TextStyle get labelSmall => GoogleFonts.poppins(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5.sp,
    height: 1.4,
  );

  // Button Text
  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.75.sp,
    height: 1.2,
  );

  // Caption
  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4.sp,
    height: 1.4,
  );

  // Overline
  static TextStyle get overline => GoogleFonts.poppins(
    fontSize: 10.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 1.5.sp,
    height: 1.4,
  );
}
