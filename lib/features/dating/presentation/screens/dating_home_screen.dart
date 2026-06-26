import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/sample_chats.dart';
import '../../data/sample_profiles.dart';
import '../../models/profile_model.dart';
import '../../theme/dating_colors.dart';
import '../../widgets/common/dating_bottom_nav.dart';
import '../../widgets/common/dating_header.dart';
import '../../widgets/profile/match_badges_row.dart';
import '../../widgets/profile/profile_card.dart';
import '../../widgets/profile/profile_card_stack.dart';
import '../../widgets/sections/about_section.dart';
import '../../widgets/sections/basics_section.dart';
import '../../widgets/sections/career_section.dart';
import '../../widgets/sections/dating_goal_card.dart';
import '../../widgets/sections/interests_section.dart';
import '../../widgets/sections/lifestyle_section.dart';
import '../../widgets/sections/media_card.dart';
import '../../widgets/compliment/compliment_bottom_sheet.dart';
import '../../widgets/sections/prompt_card.dart';
import '../../widgets/sections/video_intro_card.dart';
import 'dating_chat_detail_screen.dart';
import 'dating_chat_screen.dart';
import 'dating_date_now_screen.dart';

@RoutePage()
class DatingHomeScreen extends StatefulWidget {
  const DatingHomeScreen({super.key});

  @override
  State<DatingHomeScreen> createState() => _DatingHomeScreenState();
}

class _DatingHomeScreenState extends State<DatingHomeScreen> {
  final _scrollController = ScrollController();
  final _profiles = SampleProfiles.all;

  int _currentProfileIndex = 0;
  int _navIndex = 0;
  double _scrollOffset = 0;

  static const _collapseThreshold = 80.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() => _scrollOffset = _scrollController.offset);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  DatingProfile get _currentProfile => _profiles[_currentProfileIndex];

  void _openComplimentSheet(String sectionTitle) {
    showComplimentBottomSheet(
      context,
      sectionTitle: sectionTitle,
      onSend: () => openChatDetail(
        context,
        SampleChats.conversations.first,
      ),
    );
  }

  void _onSwipe() {
    if (_currentProfileIndex < _profiles.length - 1) {
      setState(() => _currentProfileIndex++);
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  double get _cardHeight {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final collapsed = _scrollOffset > _collapseThreshold;
    if (collapsed) return 340.h;
    return (screenHeight * 0.58).clamp(480.h, 560.h);
  }

  bool get _isCollapsed => _scrollOffset > _collapseThreshold;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: DatingColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              if (_navIndex == 0) const DatingHeader(),
              Expanded(
                child: switch (_navIndex) {
                  0 => _buildHomeContent(),
                  1 => const DatingDateNowScreen(),
                  3 => const DatingChatScreen(),
                  _ => _buildPlaceholderTab(),
                },
              ),
              DatingBottomNav(
                currentIndex: _navIndex,
                onTap: (index) => setState(() => _navIndex = index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab() {
    final label = _navIndex == 2 ? 'Admirers' : 'Events';

    return Center(
      child: Text(
        '$label — Coming soon',
        style: TextStyle(
          fontSize: 16.sp,
          color: DatingColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            height: _cardHeight,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: _isCollapsed
                ? ProfileCard(
                    profile: _currentProfile,
                    badgesOnTop: true,
                  )
                : ProfileCardStack(
                    profiles: _profiles,
                    currentIndex: _currentProfileIndex,
                    onSwipe: _onSwipe,
                    height: _cardHeight,
                  ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
            child: MatchBadgesRow(
              badges: _currentProfile.badges,
              dark: false,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
            child: AboutSection(
              about: _currentProfile.about,
              onTap: () => _openComplimentSheet('About'),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
            child: BasicsSection(items: _currentProfile.basics),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
            child: VideoIntroCard(
              thumbnailUrl: _currentProfile.videoThumbnailUrl,
              duration: _currentProfile.videoIntroDuration,
            ),
          ),
        ),
        if (_currentProfile.prompts.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
              child: PromptCard(
                prompt: _currentProfile.prompts.first,
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
            child: CareerSection(
              items: _currentProfile.career,
              bigDream: _currentProfile.bigDream,
            ),
          ),
        ),
        if (_currentProfile.thirdImageUrl != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
              child: MediaCard(
                imageUrl: _currentProfile.thirdImageUrl!,
              ),
            ),
          ),
        if (_currentProfile.prompts.length > 1)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
              child: PromptCard(
                prompt: _currentProfile.prompts[1],
                showRoseTop: false,
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
            child: InterestsSection(
              interests: _currentProfile.interests,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
            child: LifestyleSection(
              items: _currentProfile.lifestyle,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
            child: DatingGoalCard(goal: _currentProfile.datingGoal),
          ),
        ),
        if (_currentProfile.fourthImageUrl != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
              child: MediaCard(
                imageUrl: _currentProfile.fourthImageUrl!,
              ),
            ),
          ),
        if (_currentProfile.prompts.length > 2)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
              child: PromptCard(
                prompt: _currentProfile.prompts[2],
                showRoseTop: false,
                onTap: () => _openComplimentSheet('Prompt'),
              ),
            ),
          ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
      ],
    );
  }
}
