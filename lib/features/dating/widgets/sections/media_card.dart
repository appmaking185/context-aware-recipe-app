import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/dating_constants.dart';
import '../common/rose_fab.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.imageUrl,
    this.showRose = true,
  });

  final String imageUrl;
  final bool showRose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: DatingConstants.sectionRadius,
          child: AspectRatio(
            aspectRatio: 4 / 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: const Color(0xFFE0E0E0),
                    highlightColor: const Color(0xFFF5F5F5),
                    child: Container(color: const Color(0xFFE0E0E0)),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: const Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showRose)
          Positioned(
            right: 8.w,
            bottom: -12.h,
            child: const RoseFab(size: 44),
          ),
      ],
    );
  }
}
