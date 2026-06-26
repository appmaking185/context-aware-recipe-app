import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/dating_constants.dart';
import '../../models/chat_model.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';

class ChatDetailHeader extends StatelessWidget {
  const ChatDetailHeader({
    super.key,
    required this.conversation,
    required this.tier,
    required this.onBack,
  });

  final ChatConversation conversation;
  final String tier;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 4.h, 12.w, 8.h),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back_ios_new, size: 20.sp),
            color: DatingColors.textPrimary,
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundImage:
                    CachedNetworkImageProvider(conversation.imageUrl),
              ),
              if (conversation.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: DatingColors.onlineGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      conversation.name,
                      style: DatingTextStyles.basicsValue.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        tier,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFFD700),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                if (conversation.isOnline)
                  Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: DatingColors.onlineGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          _HeaderIconButton(icon: Icons.phone_outlined),
          _HeaderIconButton(icon: Icons.videocam_outlined),
          _HeaderIconButton(icon: Icons.more_vert),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Icon(icon, size: 22.sp, color: DatingColors.iconGrey),
    );
  }
}

class RelationshipProgressSection extends StatelessWidget {
  const RelationshipProgressSection({
    super.key,
    required this.level,
    required this.progress,
    required this.milestoneText,
  });

  final int level;
  final double progress;
  final String milestoneText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RELATIONSHIP PROGRESS',
                style: DatingTextStyles.sectionHeader.copyWith(
                  color: DatingColors.textSecondary,
                ),
              ),
              Text(
                'LEVEL $level',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: DatingColors.accentRose,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5.h,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(DatingColors.accentRose),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.verified, size: 14.sp, color: const Color(0xFFFFD700)),
              SizedBox(width: 6.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: DatingColors.accentRose,
                    ),
                    children: [
                      const TextSpan(text: 'Milestone reached: '),
                      TextSpan(
                        text: milestoneText,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatActionTabs extends StatelessWidget {
  const ChatActionTabs({
    super.key,
    required this.giftCount,
    required this.dateInviteCount,
    this.selectedIndex = 0,
    this.onSelected,
  });

  final int giftCount;
  final int dateInviteCount;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: _ActionTab(
              label: 'Gifts',
              icon: Icons.card_giftcard_outlined,
              badge: giftCount,
              isSelected: selectedIndex == 0,
              onTap: () => onSelected?.call(0),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _ActionTab(
              label: 'Compliments',
              icon: Icons.chat_bubble_outline,
              isSelected: selectedIndex == 1,
              onTap: () => onSelected?.call(1),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _ActionTab(
              label: 'Date Invites',
              icon: Icons.calendar_today_outlined,
              badge: dateInviteCount,
              isSelected: selectedIndex == 2,
              onTap: () => onSelected?.call(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTab extends StatelessWidget {
  const _ActionTab({
    required this.label,
    required this.icon,
    this.badge,
    this.isSelected = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final int? badge;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? DatingColors.accentRose : DatingColors.cardWhite,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected
                ? DatingColors.accentRose
                : const Color(0xFFE8E8E8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? Colors.white : DatingColors.iconGrey,
            ),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : DatingColors.textPrimary,
                ),
              ),
            ),
            if (badge != null) ...[
              SizedBox(width: 4.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : DatingColors.accentRose,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '$badge',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class DateVenueCard extends StatelessWidget {
  const DateVenueCard({
    super.key,
    required this.venueName,
  });

  final String venueName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: DatingColors.accentRose.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: DatingColors.accentRose.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 18.sp,
                color: const Color(0xFF4A9EFF),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Meet at the venue — your exact location stays private. '
                  'Have a great date!',
                  style: DatingTextStyles.basicsSubValue.copyWith(
                    fontSize: 12.sp,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Icon(
            Icons.location_on,
            size: 40.sp,
            color: DatingColors.accentRose,
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                venueName,
                style: DatingTextStyles.basicsValue.copyWith(fontSize: 16.sp),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.location_on, size: 14.sp, color: DatingColors.accentRose),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DatingColors.accentRose,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    'Add to calendar',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: DatingColors.textPrimary,
                    side: const BorderSide(color: Color(0xFFE8E8E8)),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    'Get directions',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatDateSeparator extends StatelessWidget {
  const ChatDateSeparator({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: DatingColors.cardWhite,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: DatingConstants.softShadow,
        ),
        child: Text(
          label,
          style: DatingTextStyles.basicsSubValue.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class OutgoingMessageBubble extends StatelessWidget {
  const OutgoingMessageBubble({
    super.key,
    required this.text,
    required this.time,
    this.avatarUrl,
  });

  final String text;
  final String time;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 10.h),
              decoration: BoxDecoration(
                color: DatingColors.accentRose,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                  bottomLeft: Radius.circular(18.r),
                  bottomRight: Radius.circular(4.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.done_all,
                        size: 14.sp,
                        color: const Color(0xFF4A9EFF),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          if (avatarUrl != null)
            CircleAvatar(
              radius: 14.r,
              backgroundImage: CachedNetworkImageProvider(avatarUrl!),
            ),
        ],
      ),
    );
  }
}

class GiftMessageCard extends StatelessWidget {
  const GiftMessageCard({
    super.key,
    required this.giftName,
    required this.coins,
    required this.note,
  });

  final String giftName;
  final int coins;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: DatingColors.cardWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: DatingConstants.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: DatingColors.accentRose.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text('🌹', style: TextStyle(fontSize: 24.sp)),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      giftName,
                      style: DatingTextStyles.basicsValue.copyWith(
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          '$coins coins',
                          style: DatingTextStyles.basicsSubValue,
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.monetization_on,
                          size: 14.sp,
                          color: const Color(0xFFFFD700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: DatingColors.accentRose.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'SENT',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: DatingColors.accentRose,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            note,
            style: DatingTextStyles.basicsSubValue.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.recipientName,
  });

  final String recipientName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: DatingColors.cardWhite,
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _CircleIcon(icon: Icons.add),
            SizedBox(width: 8.w),
            _CircleIcon(icon: Icons.image_outlined),
            SizedBox(width: 8.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Message $recipientName...',
                        style: DatingTextStyles.basicsSubValue,
                      ),
                    ),
                    Icon(
                      Icons.mic_none,
                      size: 20.sp,
                      color: DatingColors.iconGrey,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(
                color: DatingColors.accentRose,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send_rounded,
                size: 20.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20.sp, color: DatingColors.iconGrey),
    );
  }
}
