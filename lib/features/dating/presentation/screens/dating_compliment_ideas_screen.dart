import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/dating_constants.dart';
import '../../data/sample_compliment_ideas.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';

Future<String?> openComplimentIdeasScreen(BuildContext context) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(
      builder: (_) => const DatingComplimentIdeasScreen(),
    ),
  );
}

class DatingComplimentIdeasScreen extends StatefulWidget {
  const DatingComplimentIdeasScreen({super.key});

  @override
  State<DatingComplimentIdeasScreen> createState() =>
      _DatingComplimentIdeasScreenState();
}

class _DatingComplimentIdeasScreenState
    extends State<DatingComplimentIdeasScreen> {
  int _categoryIndex = 3;
  int? _selectedIdeaIndex;

  ComplimentCategory get _category =>
      SampleComplimentIdeas.categories[_categoryIndex];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: DatingColors.cardWhite,
        body: Column(
          children: [
            _IdeasHeader(onBack: () => Navigator.of(context).pop()),
            SizedBox(height: 8.h),
            _CategoryChips(
              categories: SampleComplimentIdeas.categories,
              selectedIndex: _categoryIndex,
              onSelected: (index) => setState(() {
                _categoryIndex = index;
                _selectedIdeaIndex = null;
              }),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                itemCount: _category.ideas.length,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final idea = _category.ideas[index];
                  final isSelected = _selectedIdeaIndex == index;

                  return _IdeaCard(
                    text: idea,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedIdeaIndex = index),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                child: _UseComplimentButton(
                  enabled: _selectedIdeaIndex != null,
                  onTap: _selectedIdeaIndex != null
                      ? () {
                          final idea = _category.ideas[_selectedIdeaIndex!];
                          Navigator.of(context).pop(idea);
                        }
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdeasHeader extends StatelessWidget {
  const _IdeasHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(8.w, topInset + 8.h, 8.w, 24.h),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF8E8EE),
                DatingColors.cardWhite,
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: DatingColors.cardWhite,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: DatingColors.textPrimary,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.more_horiz,
                  size: 28.sp,
                  color: DatingColors.textPrimary,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'Compliment Ideas',
                style: DatingTextStyles.promptBody.copyWith(fontSize: 22.sp),
              ),
              SizedBox(height: 6.h),
              Text(
                'pick one to make a great first impression',
                style:
                    DatingTextStyles.basicsSubValue.copyWith(fontSize: 14.sp),
              ),
            ],
          ),
        ),
        Positioned(
          top: topInset + 4.h,
          left: 4.w,
          child: IconButton(
            onPressed: onBack,
            icon: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: DatingColors.cardWhite.withValues(alpha: 0.9),
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
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<ComplimentCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
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
                    : const Color(0xFFF5F2ED),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? DatingColors.accentRose
                      : const Color(0xFFE8E8E8),
                ),
              ),
              child: Center(
                child: Text(
                  categories[index].name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color:
                        isSelected ? Colors.white : DatingColors.textPrimary,
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

class _IdeaCard extends StatelessWidget {
  const _IdeaCard({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: DatingColors.cardWhite,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color:
                isSelected ? DatingColors.accentRose : const Color(0xFFECE8E3),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? null : DatingConstants.softShadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: DatingTextStyles.aboutBody.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 8.w),
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
          ],
        ),
      ),
    );
  }
}

class _UseComplimentButton extends StatelessWidget {
  const _UseComplimentButton({
    required this.enabled,
    this.onTap,
  });

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled
              ? DatingColors.accentRose
              : const Color(0xFFF0E6E0),
          borderRadius: BorderRadius.circular(26.r),
        ),
        child: Text(
          'Use this compliment',
          style: DatingTextStyles.basicsValue.copyWith(
            fontSize: 16.sp,
            color: enabled ? Colors.white : DatingColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
