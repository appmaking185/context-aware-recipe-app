import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/dating_constants.dart';
import '../../models/notification_model.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';

class NotificationsHeader extends StatelessWidget {
  const NotificationsHeader({
    super.key,
    required this.newCount,
    required this.onBack,
    this.onMarkAllRead,
  });

  final int newCount;
  final VoidCallback onBack;
  final VoidCallback? onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onBack,
            icon: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: DatingColors.cardWhite,
                shape: BoxShape.circle,
                boxShadow: DatingConstants.softShadow,
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18.sp,
                color: DatingColors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: DatingTextStyles.basicsValue.copyWith(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  '$newCount new updates',
                  style: DatingTextStyles.basicsSubValue,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onMarkAllRead,
            child: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Text(
                'Mark all read',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: DatingColors.accentRose,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationFilterChips extends StatelessWidget {
  const NotificationFilterChips({
    super.key,
    required this.labels,
    required this.totalCount,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int totalCount;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: labels.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          final label = index == 0 ? '${labels[index]} $totalCount' : labels[index];

          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? DatingColors.textPrimary
                    : DatingColors.cardWhite,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? DatingColors.textPrimary
                      : const Color(0xFFE8E8E8),
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : DatingColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
  });

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final n = notification;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: DatingColors.cardWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: DatingConstants.softShadow,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (n.isUnread)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: DatingColors.accentRose,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationAvatar(notification: n),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NotificationTitle(notification: n),
                    if (n.subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        n.subtitle!,
                        style: DatingTextStyles.basicsLabel.copyWith(
                          fontSize: 13.sp,
                          height: 1.4,
                        ),
                      ),
                    ],
                    if (n.quote != null) ...[
                      SizedBox(height: 6.h),
                      Text(
                        '"${n.quote!}"',
                        style: DatingTextStyles.basicsSubValue.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                    ],
                    SizedBox(height: 8.h),
                    Text(
                      n.timestamp,
                      style: DatingTextStyles.basicsSubValue.copyWith(
                        fontSize: 11.sp,
                      ),
                    ),
                    if (n.actionLabel != null) ...[
                      SizedBox(height: 10.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DatingColors.accentRose,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                          ),
                          child: Text(
                            n.actionLabel!,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationAvatar extends StatelessWidget {
  const _NotificationAvatar({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    if (notification.type == NotificationType.dateApproved) {
      return Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(
          Icons.calendar_month_outlined,
          size: 24.sp,
          color: const Color(0xFFFF9800),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundImage: notification.imageUrl != null
              ? CachedNetworkImageProvider(notification.imageUrl!)
              : null,
          child: notification.imageUrl == null
              ? Icon(Icons.person, color: DatingColors.iconGrey)
              : null,
        ),
        Positioned(
          right: -2.w,
          bottom: -2.h,
          child: _TypeBadge(type: notification.type),
        ),
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final NotificationType type;

  @override
  Widget build(BuildContext context) {
    final (icon, color, child) = switch (type) {
      NotificationType.rose => (
          Icons.local_florist,
          DatingColors.accentRose,
          Text('🌹', style: TextStyle(fontSize: 10.sp)),
        ),
      NotificationType.compliment => (
          Icons.chat_bubble_outline,
          const Color(0xFFFFB800),
          null,
        ),
      NotificationType.match => (
          Icons.favorite,
          DatingColors.onlineGreen,
          null,
        ),
      NotificationType.message => (
          Icons.chat_bubble,
          DatingColors.accentRose,
          null,
        ),
      NotificationType.dateApproved => (
          Icons.calendar_today,
          const Color(0xFFFF9800),
          null,
        ),
    };

    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: child ??
            Icon(icon, size: 10.sp, color: Colors.white),
      ),
    );
  }
}

class _NotificationTitle extends StatelessWidget {
  const _NotificationTitle({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final text = notification.title;
    final name = notification.name;
    final age = notification.age;

    if (name == null) {
      return Text(
        text,
        style: DatingTextStyles.basicsValue.copyWith(fontSize: 14.sp),
      );
    }

    final nameAge = age != null ? '$name, $age' : name;
    if (!text.contains(nameAge)) {
      return Text(
        text,
        style: DatingTextStyles.basicsValue.copyWith(fontSize: 14.sp),
      );
    }

    final parts = text.split(nameAge);
    return RichText(
      text: TextSpan(
        style: DatingTextStyles.basicsLabel.copyWith(
          fontSize: 14.sp,
          color: DatingColors.textPrimary,
          height: 1.3,
        ),
        children: [
          if (parts[0].isNotEmpty) TextSpan(text: parts[0]),
          TextSpan(
            text: nameAge,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }
}
