import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/dating_constants.dart';
import '../../models/chat_model.dart';
import '../../presentation/screens/dating_chat_detail_screen.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';

class ChatConversationTile extends StatelessWidget {
  const ChatConversationTile({
    super.key,
    required this.conversation,
  });

  final ChatConversation conversation;

  @override
  Widget build(BuildContext context) {
    final chat = conversation;

    return GestureDetector(
      onTap: () => openChatDetail(context, chat),
      child: Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: DatingColors.cardWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: DatingConstants.softShadow,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 26.r,
                    backgroundImage:
                        CachedNetworkImageProvider(chat.imageUrl),
                  ),
                  if (chat.isOnline)
                    Positioned(
                      right: 2.w,
                      bottom: 2.h,
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: DatingColors.onlineGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${chat.name}, ${chat.age}',
                          style: DatingTextStyles.basicsValue.copyWith(
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: DatingColors.accentRose
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '${chat.matchPercent}% Match',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: DatingColors.accentRose,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (chat.unreadCount > 0)
                          Container(
                            width: 20.w,
                            height: 20.w,
                            margin: EdgeInsets.only(right: 6.w),
                            decoration: const BoxDecoration(
                              color: DatingColors.accentRose,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${chat.unreadCount}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        Text(
                          chat.timestamp,
                          style: DatingTextStyles.basicsSubValue,
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      chat.isTyping
                          ? 'Typing...'
                          : chat.isFromMe
                              ? 'You: ${chat.lastMessage}'
                              : chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DatingTextStyles.basicsLabel.copyWith(
                        color: chat.isTyping
                            ? DatingColors.accentRose
                            : DatingColors.textTertiary,
                        fontStyle:
                            chat.isTyping ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: chat.progress,
                    minHeight: 4.h,
                    backgroundColor: const Color(0xFFEEEEEE),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      chat.progressColor ?? DatingColors.accentRose,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                chat.giftUnlocked ? '🎁 ${chat.progressLabel}' : chat.progressLabel,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: chat.giftUnlocked
                      ? DatingColors.onlineGreen
                      : DatingColors.textTertiary,
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
