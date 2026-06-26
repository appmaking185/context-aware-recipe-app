import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/profile_model.dart';
import '../common/info_badge.dart';

class MatchBadgesRow extends StatelessWidget {
  const MatchBadgesRow({
    super.key,
    required this.badges,
    this.dark = true,
    this.spacing = 6,
  });

  final List<ProfileBadge> badges;
  final bool dark;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing.w,
      runSpacing: 6.h,
      children: badges
          .map((b) => InfoBadge(badge: b, dark: dark))
          .toList(),
    );
  }
}
