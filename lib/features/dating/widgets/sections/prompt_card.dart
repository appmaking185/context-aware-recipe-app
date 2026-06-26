import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/dating_constants.dart';
import '../../models/profile_model.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';
import '../common/rose_fab.dart';

class PromptCard extends StatelessWidget {
  const PromptCard({
    super.key,
    required this.prompt,
    this.showRoseTop = true,
    this.onTap,
  });

  final ProfilePrompt prompt;
  final bool showRoseTop;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: showRoseTop ? 14.h : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
              decoration: BoxDecoration(
                color: DatingColors.cardWhite,
                borderRadius: DatingConstants.sectionRadius,
                boxShadow: DatingConstants.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prompt.header,
                    style: DatingTextStyles.promptHeader,
                  ),
                  SizedBox(height: 10.h),
                  Text(prompt.body, style: DatingTextStyles.promptBody),
                  SizedBox(height: 8.h),
                  const RoseIconSmall(size: 28),
                ],
              ),
            ),
          ),
          if (showRoseTop)
            Positioned(
              top: -14.h,
              right: 10.w,
              child: const RoseIconSmall(size: 30),
            ),
        ],
      ),
    );
  }
}
