import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/dating_text_styles.dart';
import '../common/rose_fab.dart';
import '../common/section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
    required this.about,
    this.onTap,
  });

  final String about;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'About'),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 40.w),
                child: Text(about, style: DatingTextStyles.aboutBody),
              ),
              Positioned(
                right: 0,
                bottom: -4.h,
                child: const RoseIconSmall(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
