import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/dating_constants.dart';
import '../../models/profile_model.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';
import '../common/rose_fab.dart';

class DatingGoalCard extends StatelessWidget {
  const DatingGoalCard({
    super.key,
    required this.goal,
  });

  final DatingGoal goal;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: DatingColors.datingGoalCard,
            borderRadius: DatingConstants.sectionRadius,
            boxShadow: DatingConstants.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DATING GOAL', style: DatingTextStyles.datingGoalLabel),
              SizedBox(height: 10.h),
              Text(goal.title, style: DatingTextStyles.datingGoalTitle),
              SizedBox(height: 8.h),
              Text(goal.description, style: DatingTextStyles.datingGoalBody),
            ],
          ),
        ),
        Positioned(
          right: -4.w,
          top: -8.h,
          child: const RoseIconSmall(size: 28),
        ),
      ],
    );
  }
}
