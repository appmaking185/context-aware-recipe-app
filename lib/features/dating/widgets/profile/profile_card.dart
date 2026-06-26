import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/dating_constants.dart';
import '../../models/profile_model.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';
import '../common/circular_action_button.dart';
import '../common/rose_fab.dart';
import 'match_badges_row.dart';
import 'profile_info_row.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.profile,
    this.badgesOnTop = false,
    this.showTopActions = true,
    this.showRoseFab = true,
    this.onMoreTap,
    this.onUndoTap,
  });

  final DatingProfile profile;
  final bool badgesOnTop;
  final bool showTopActions;
  final bool showRoseFab;
  final VoidCallback? onMoreTap;
  final VoidCallback? onUndoTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: DatingConstants.cardRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: profile.imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor: const Color(0xFFE0E0E0),
              highlightColor: const Color(0xFFF5F5F5),
              child: Container(color: const Color(0xFFE0E0E0)),
            ),
            errorWidget: (_, __, ___) => Container(
              color: const Color(0xFF2C2C2C),
              child: Icon(Icons.person, size: 64.sp, color: Colors.white54),
            ),
          ),
          if (showTopActions)
            Positioned(
              top: 14.h,
              left: 14.w,
              right: 14.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircularActionButton(
                    icon: Icons.replay,
                    size: DatingConstants.smallButtonSize.w,
                    backgroundColor: Colors.white.withValues(alpha: 0.85),
                    onTap: onUndoTap,
                  ),
                  CircularActionButton(
                    icon: Icons.more_vert,
                    size: DatingConstants.smallButtonSize.w,
                    backgroundColor: Colors.white.withValues(alpha: 0.85),
                    onTap: onMoreTap,
                  ),
                ],
              ),
            ),
          if (badgesOnTop)
            Positioned(
              top: 60.h,
              left: 16.w,
              child: MatchBadgesRow(badges: profile.badges),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0.0, 0.35, 1.0],
                ),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 48.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!badgesOnTop) ...[
                    MatchBadgesRow(badges: profile.badges),
                    SizedBox(height: 10.h),
                  ],
                  Row(
                    children: [
                      if (profile.isOnline)
                        Container(
                          width: 8.w,
                          height: 8.w,
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: const BoxDecoration(
                            color: DatingColors.onlineGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        '${profile.name} ${profile.age}',
                        style: DatingTextStyles.profileName,
                      ),
                      if (profile.isVerified) ...[
                        SizedBox(width: 8.w),
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: const BoxDecoration(
                            color: DatingColors.verifiedRed,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ProfileInfoRow(
                    icon: Icons.location_on_outlined,
                    text: '${profile.location} · ${profile.distance}',
                  ),
                  ProfileInfoRow(
                    icon: Icons.work_outline,
                    text: '${profile.occupation} · ${profile.height}',
                  ),
                  ProfileInfoRow(
                    icon: Icons.favorite_border,
                    text: profile.intent,
                  ),
                ],
              ),
            ),
          ),
          if (showRoseFab)
            Positioned(
              right: 16.w,
              bottom: 16.h,
              child: RoseFab(onTap: () {}),
            ),
        ],
      ),
    );
  }
}
