import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/dating_constants.dart';
import '../../theme/dating_colors.dart';

class CircularActionButton extends StatelessWidget {
  const CircularActionButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size,
    this.iconColor,
    this.backgroundColor,
    this.showShadow = true,
    this.badge,
    this.iconSize,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double? size;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool showShadow;
  final bool? badge;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? DatingConstants.buttonSize.w;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: backgroundColor ?? DatingColors.cardWhite,
          shape: BoxShape.circle,
          boxShadow: showShadow ? DatingConstants.softShadow : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              size: iconSize ?? 20.sp,
              color: iconColor ?? DatingColors.iconGrey,
            ),
            if (badge == true)
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  width: 7.w,
                  height: 7.w,
                  decoration: const BoxDecoration(
                    color: DatingColors.notificationDot,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
