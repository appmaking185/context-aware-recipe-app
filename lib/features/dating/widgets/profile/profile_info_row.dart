import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';

class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.light = true,
  });

  final IconData icon;
  final String text;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: light ? Colors.white.withValues(alpha: 0.9) : DatingColors.iconGrey,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: light
                  ? DatingTextStyles.profileDetail
                  : DatingTextStyles.basicsLabel,
            ),
          ),
        ],
      ),
    );
  }
}
