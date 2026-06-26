import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/chat_model.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';

class ChatSearchBar extends StatelessWidget {
  const ChatSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: DatingColors.cardWhite,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 20.sp, color: DatingColors.textSecondary),
          SizedBox(width: 10.w),
          Text(
            'Search matches or messages',
            style: DatingTextStyles.basicsLabel.copyWith(
              color: DatingColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class NewMatchesSection extends StatelessWidget {
  const NewMatchesSection({
    super.key,
    required this.matches,
  });

  final List<NewMatch> matches;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('NEW MATCHES', style: DatingTextStyles.sectionHeader),
              Text(
                'See all →',
                style: DatingTextStyles.basicsSubValue.copyWith(
                  color: DatingColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 96.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: matches.length,
            separatorBuilder: (_, __) => SizedBox(width: 14.w),
            itemBuilder: (context, index) {
              return _NewMatchAvatar(match: matches[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _NewMatchAvatar extends StatelessWidget {
  const _NewMatchAvatar({required this.match});

  final NewMatch match;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64.w,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: DatingColors.accentRose.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 28.r,
                  backgroundImage:
                      CachedNetworkImageProvider(match.imageUrl),
                ),
              ),
              if (match.isNew)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: DatingColors.accentRose,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'NEW',
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              if (match.hasBoost)
                Positioned(
                  top: 2.h,
                  right: 0,
                  child: Icon(
                    Icons.bolt,
                    size: 14.sp,
                    color: const Color(0xFFFF9F0A),
                  ),
                ),
              if (match.hasVideo)
                Positioned(
                  top: 2.h,
                  right: 0,
                  child: Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      color: DatingColors.accentRose,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            match.name,
            style: DatingTextStyles.basicsLabel.copyWith(
              fontSize: 12.sp,
              color: DatingColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class ChatFilterChips extends StatelessWidget {
  const ChatFilterChips({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: labels.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? DatingColors.accentRose
                    : DatingColors.cardWhite,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? DatingColors.accentRose
                      : const Color(0xFFE8E8E8),
                ),
              ),
              child: Text(
                labels[index],
                style: DatingTextStyles.basicsLabel.copyWith(
                  color: isSelected ? Colors.white : DatingColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
