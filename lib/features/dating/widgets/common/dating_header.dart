import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../presentation/screens/dating_notifications_screen.dart';
import '../../constants/dating_constants.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';
import '../../presentation/screens/dating_compliment_ideas_screen.dart';
import 'circular_action_button.dart';

class DatingHeader extends StatelessWidget {
  const DatingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: CircularActionButton(
                icon: Icons.menu,
                onTap: () => openComplimentIdeasScreen(context),
              ),
            ),
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: _DailyPill(),
            ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularActionButton(
                      icon: Icons.bolt_outlined,
                      onTap: () {},
                    ),
                    SizedBox(width: 6.w),
                    CircularActionButton(
                      icon: Icons.tune,
                      onTap: () {},
                    ),
                    SizedBox(width: 6.w),
                    CircularActionButton(
                      icon: Icons.notifications_none_outlined,
                      badge: true,
                      onTap: () => openNotificationsScreen(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: DatingColors.cardWhite,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: DatingConstants.softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.w,
            height: 7.w,
            decoration: const BoxDecoration(
              color: DatingColors.dailyDot,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Text('Daily 25', style: DatingTextStyles.dailyPill),
        ],
      ),
    );
  }
}
