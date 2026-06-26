import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/dating_constants.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';

class VideoIntroCard extends StatelessWidget {
  const VideoIntroCard({
    super.key,
    required this.thumbnailUrl,
    required this.duration,
  });

  final String thumbnailUrl;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: DatingConstants.sectionRadius,
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: thumbnailUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: const Color(0xFFE0E0E0),
                highlightColor: const Color(0xFFF5F5F5),
                child: Container(color: const Color(0xFFE0E0E0)),
              ),
              errorWidget: (_, __, ___) => Container(
                color: const Color(0xFF333333),
                child: Icon(Icons.person, size: 48.sp, color: Colors.white54),
              ),
            ),
            Center(
              child: Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: DatingColors.textPrimary,
                  size: 30.sp,
                ),
              ),
            ),
            Positioned(
              left: 12.w,
              bottom: 12.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Video intro · $duration',
                  style: DatingTextStyles.videoLabel,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
