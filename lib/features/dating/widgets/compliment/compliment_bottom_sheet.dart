import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/dating_constants.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';
import '../../presentation/screens/dating_compliment_ideas_screen.dart';
import '../common/dating_sheet_layout.dart';

const _maxChars = 140;

void showComplimentBottomSheet(
  BuildContext context, {
  required String sectionTitle,
  VoidCallback? onSend,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => wrapFixedBottomSheet(
      sheetContext,
      height: complimentSheetHeight,
      child: ComplimentBottomSheet(
        sectionTitle: sectionTitle,
        onSend: onSend,
      ),
    ),
  );
}

class ComplimentBottomSheet extends StatefulWidget {
  const ComplimentBottomSheet({
    super.key,
    required this.sectionTitle,
    this.onSend,
  });

  final String sectionTitle;
  final VoidCallback? onSend;

  @override
  State<ComplimentBottomSheet> createState() => _ComplimentBottomSheetState();
}

class _ComplimentBottomSheetState extends State<ComplimentBottomSheet> {
  final _controller = TextEditingController();
  bool _roseSelected = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSend => _controller.text.trim().isNotEmpty;

  Future<void> _openComplimentIdeas() async {
    final idea = await openComplimentIdeasScreen(context);
    if (!mounted || idea == null) return;

    setState(() => _controller.text = idea);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Compliment added ✨',
          style: DatingTextStyles.basicsValue.copyWith(color: Colors.white),
        ),
        backgroundColor: DatingColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        margin: EdgeInsets.fromLTRB(40.w, 0, 40.w, 120.h),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleSend() {
    if (!_canSend) return;
    Navigator.of(context).pop();
    widget.onSend?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DatingColors.cardWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Text(
              'COMPLIMENTING',
              style: DatingTextStyles.sectionHeader.copyWith(
                color: DatingColors.textSecondary,
                fontSize: 11.sp,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              widget.sectionTitle,
              style: DatingTextStyles.promptBody.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 14.h),
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _StatsRow(),
                    SizedBox(height: 14.h),
                    _ComplimentInput(
                      controller: _controller,
                      onChanged: (_) => setState(() {}),
                      onTryTap: _openComplimentIdeas,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: _GiftChip(
                            label: 'Rose',
                            icon: '🌹',
                            selected: _roseSelected,
                            onTap: () => setState(() => _roseSelected = true),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _GiftChip(
                            label: 'Select Gift',
                            icon: '🎁',
                            onTap: () => setState(() => _roseSelected = false),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_controller.text.length}/$_maxChars',
                        style: DatingTextStyles.basicsSubValue.copyWith(
                          fontSize: 12.sp,
                          color: DatingColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _LikeButton(
                  highlighted: !_canSend,
                  onTap: () {},
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _SendButton(
                    enabled: _canSend,
                    onTap: _canSend ? _handleSend : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _StatPill(
            icon: Icons.chat_bubble_outline,
            label: '3 comments',
          ),
          SizedBox(width: 8.w),
          _StatPill(
            emoji: '🌹',
            label: '2 roses',
          ),
          SizedBox(width: 8.w),
          _StatPill(
            emoji: '🪙',
            label: '5,258 balance',
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    this.icon,
    this.emoji,
    required this.label,
  });

  final IconData? icon;
  final String? emoji;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F2ED),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: 14.sp, color: DatingColors.iconGrey)
          else
            Text(emoji!, style: TextStyle(fontSize: 12.sp)),
          SizedBox(width: 5.w),
          Text(
            label,
            style: DatingTextStyles.basicsSubValue.copyWith(
              fontSize: 12.sp,
              color: DatingColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComplimentInput extends StatelessWidget {
  const _ComplimentInput({
    required this.controller,
    required this.onChanged,
    this.onTryTap,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DatingColors.cardWhite,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            maxLength: _maxChars,
            maxLines: 3,
            minLines: 3,
            style: DatingTextStyles.aboutBody.copyWith(
              fontSize: 15.sp,
              height: 1.45,
            ),
            decoration: InputDecoration(
              hintText: 'Write a sweet compliment...',
              hintStyle: DatingTextStyles.basicsSubValue.copyWith(
                fontSize: 15.sp,
                color: const Color(0xFFB0B0B0),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 52.h),
              counterText: '',
            ),
          ),
          Positioned(
            right: 12.w,
            bottom: 12.h,
            child: GestureDetector(
              onTap: onTryTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: DatingColors.cardWhite,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                  boxShadow: DatingConstants.softShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 15.sp,
                      color: const Color(0xFFFFB800),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Try',
                      style: DatingTextStyles.basicsSubValue.copyWith(
                        fontWeight: FontWeight.w600,
                        color: DatingColors.textPrimary,
                        fontSize: 13.sp,
                      ),
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

class _GiftChip extends StatelessWidget {
  const _GiftChip({
    required this.label,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final String icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFFF0F3)
              : DatingColors.cardWhite,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: selected
                ? DatingColors.accentRose
                : const Color(0xFFE5E5E5),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: TextStyle(fontSize: 17.sp)),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: DatingTextStyles.basicsValue.copyWith(fontSize: 14.sp),
              ),
            ),
            if (selected)
              Container(
                width: 22.w,
                height: 22.w,
                decoration: const BoxDecoration(
                  color: DatingColors.accentRose,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 14.sp,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LikeButton extends StatelessWidget {
  const _LikeButton({
    required this.highlighted,
    this.onTap,
  });

  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        highlighted ? DatingColors.accentRose : const Color(0xFFE0E0E0);
    final iconColor =
        highlighted ? DatingColors.accentRose : DatingColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58.w,
        height: 58.w,
        decoration: BoxDecoration(
          color: DatingColors.cardWhite,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              size: 20.sp,
              color: iconColor,
            ),
            SizedBox(height: 2.h),
            Text(
              'Like',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.enabled,
    this.onTap,
  });

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 58.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled
              ? DatingColors.accentRose
              : const Color(0xFFF3D4DA),
          borderRadius: BorderRadius.circular(29.r),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: DatingColors.accentRose.withValues(alpha: 0.35),
                    blurRadius: 14.r,
                    offset: Offset(0, 6.h),
                  ),
                ]
              : null,
        ),
        child: enabled
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Send',
                    style: DatingTextStyles.basicsValue.copyWith(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text('🌹', style: TextStyle(fontSize: 17.sp)),
                  SizedBox(width: 6.w),
                  Text(
                    '+',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.chat_bubble,
                    size: 17.sp,
                    color: Colors.white,
                  ),
                ],
              )
            : Text(
                'Send Compliment',
                style: DatingTextStyles.basicsValue.copyWith(
                  fontSize: 16.sp,
                  color: Colors.white.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
