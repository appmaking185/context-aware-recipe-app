import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/profile_model.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';
import '../common/section_header.dart';

class InterestsSection extends StatelessWidget {
  const InterestsSection({
    super.key,
    required this.interests,
  });

  final List<InterestItem> interests;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Interests & Hobbies'),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: interests.map(_InterestChip.new).toList(),
        ),
      ],
    );
  }
}

class _InterestChip extends StatelessWidget {
  const _InterestChip(this.item);

  final InterestItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: DatingColors.cardWhite,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
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
          Icon(
            item.icon,
            size: 16.sp,
            color: DatingColors.basicsIcon,
          ),
          SizedBox(width: 8.w),
          Text(item.label, style: DatingTextStyles.interestChip),
        ],
      ),
    );
  }
}
