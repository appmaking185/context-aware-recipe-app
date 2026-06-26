import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/sample_chat_details.dart';
import '../../models/chat_model.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';
import '../../widgets/chat/chat_detail_widgets.dart';

class DatingChatDetailScreen extends StatefulWidget {
  const DatingChatDetailScreen({
    super.key,
    required this.detail,
  });

  final ChatDetailData detail;

  @override
  State<DatingChatDetailScreen> createState() => _DatingChatDetailScreenState();
}

class _DatingChatDetailScreenState extends State<DatingChatDetailScreen> {
  int _actionTabIndex = 0;

  ChatDetailData get _detail => widget.detail;

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
              ChatDetailHeader(
                conversation: _detail.conversation,
                tier: _detail.tier,
                onBack: () => Navigator.of(context).pop(),
              ),
              RelationshipProgressSection(
                level: _detail.level,
                progress: _detail.relationshipProgress,
                milestoneText: _detail.milestoneText,
              ),
              ChatActionTabs(
                giftCount: _detail.giftCount,
                dateInviteCount: _detail.dateInviteCount,
                selectedIndex: _actionTabIndex,
                onSelected: (index) => setState(() => _actionTabIndex = index),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 8.h),
                  children: [
                    DateVenueCard(venueName: _detail.venueName),
                    const ChatDateSeparator(label: 'TODAY'),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Text(
                          "You reacted to ${_detail.conversation.name}'s About",
                          style: DatingTextStyles.basicsSubValue,
                        ),
                      ),
                    ),
                    ..._detail.messages.map(_buildMessage),
                  ],
                ),
              ),
              ChatInputBar(recipientName: _detail.conversation.name),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessageItem message) {
    switch (message.type) {
      case ChatMessageType.system:
        return const SizedBox.shrink();
      case ChatMessageType.outgoing:
        return OutgoingMessageBubble(
          text: message.text ?? '',
          time: message.time ?? '',
          avatarUrl: message.senderImageUrl,
        );
      case ChatMessageType.gift:
        return GiftMessageCard(
          giftName: message.giftName ?? 'Gift',
          coins: message.giftCoins ?? 0,
          note: message.giftNote ?? '',
        );
    }
  }
}

void openChatDetail(BuildContext context, ChatConversation conversation) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => DatingChatDetailScreen(
        detail: SampleChatDetails.detailFor(conversation),
      ),
    ),
  );
}
