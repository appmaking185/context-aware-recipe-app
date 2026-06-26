import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Fixed compliment composer sheet height (when keyboard is closed).
double get complimentSheetHeight => 520.h;

/// Wraps a bottom sheet with a fixed height that respects the status bar and keyboard.
Widget wrapFixedBottomSheet(
  BuildContext context, {
  required double height,
  required Widget child,
}) {
  final media = MediaQuery.of(context);
  final topInset = media.viewPadding.top;
  final bottomSafe = media.viewPadding.bottom;
  final keyboardInset = media.viewInsets.bottom;
  final topGap = 8.h;

  final maxHeight = media.size.height - topInset - topGap - bottomSafe;
  final sheetHeight = height.clamp(0.0, maxHeight);

  return Padding(
    padding: EdgeInsets.only(
      top: topInset + topGap,
      bottom: keyboardInset > 0 ? keyboardInset : bottomSafe,
    ),
    child: Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        height: keyboardInset > 0
            ? null
            : sheetHeight,
        constraints: BoxConstraints(
          maxHeight: keyboardInset > 0
              ? media.size.height - topInset - topGap - keyboardInset
              : sheetHeight,
        ),
        width: double.infinity,
        child: child,
      ),
    ),
  );
}
