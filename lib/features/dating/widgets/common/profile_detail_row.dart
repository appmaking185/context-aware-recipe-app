import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';

/// Reusable label/value row for Basics, Career, and Lifestyle cards.
class ProfileDetailRow extends StatelessWidget {
  const ProfileDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subValue,
    this.valueStyle,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subValue;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: DatingColors.basicsIcon,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Text(label, style: DatingTextStyles.basicsLabel),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: valueStyle ?? DatingTextStyles.basicsValue,
                textAlign: TextAlign.right,
              ),
              if (subValue != null) ...[
                SizedBox(height: 2.h),
                Text(
                  subValue!,
                  style: DatingTextStyles.basicsSubValue,
                  textAlign: TextAlign.right,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
