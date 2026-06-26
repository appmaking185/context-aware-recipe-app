import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/profile_model.dart';
import '../../theme/dating_text_styles.dart';

class InfoBadge extends StatelessWidget {
  const InfoBadge({
    super.key,
    required this.badge,
    this.dark = true,
  });

  final ProfileBadge badge;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: dark
            ? Colors.black.withValues(alpha: 0.45)
            : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: dark
            ? null
            : Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4.r,
                  offset: Offset(0, 2.h),
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: badge.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            badge.label,
            style: dark
                ? DatingTextStyles.badgeText
                : DatingTextStyles.badgeTextLight,
          ),
        ],
      ),
    );
  }
}
