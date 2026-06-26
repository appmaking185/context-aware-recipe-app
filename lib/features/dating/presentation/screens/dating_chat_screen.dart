import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/sample_chats.dart';
import '../../models/chat_model.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';
import '../../widgets/chat/chat_conversation_tile.dart';
import '../../widgets/chat/chat_header_widgets.dart';

class DatingChatScreen extends StatefulWidget {
  const DatingChatScreen({super.key});

  @override
  State<DatingChatScreen> createState() => _DatingChatScreenState();
}

class _DatingChatScreenState extends State<DatingChatScreen> {
  int _filterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
          child: Row(
            children: [
              Text(
                'Messages',
                style: DatingTextStyles.basicsValue.copyWith(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: DatingColors.cardWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8.r,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.settings_outlined,
                  size: 20.sp,
                  color: DatingColors.iconGrey,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          child: const ChatSearchBar(),
        ),
        SizedBox(height: 20.h),
        NewMatchesSection(matches: SampleChats.newMatches),
        SizedBox(height: 16.h),
        ChatFilterChips(
          labels: SampleChats.filterLabels,
          selectedIndex: _filterIndex,
          onSelected: (index) => setState(() => _filterIndex = index),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 8.h),
            itemCount: _filteredConversations.length,
            itemBuilder: (context, index) {
              return ChatConversationTile(
                conversation: _filteredConversations[index],
              );
            },
          ),
        ),
      ],
    );
  }

  List<ChatConversation> get _filteredConversations {
    final all = SampleChats.conversations;
    switch (_filterIndex) {
      case 1:
        return all.where((c) => c.unreadCount > 0).toList();
      case 2:
        return all.where((c) => c.isOnline).toList();
      default:
        return all;
    }
  }
}
