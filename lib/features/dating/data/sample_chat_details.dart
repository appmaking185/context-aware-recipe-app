import '../models/chat_model.dart';
import 'sample_chats.dart';

class SampleChatDetails {
  SampleChatDetails._();

  static ChatDetailData detailFor(ChatConversation conversation) {
    return ChatDetailData(
      conversation: conversation,
      level: 5,
      relationshipProgress: 0.82,
      milestoneText: 'Premium Badge unlocked',
      giftCount: 12,
      dateInviteCount: 3,
      venueName: 'Blue Tokai',
      messages: const [
        ChatMessageItem(type: ChatMessageType.system),
        ChatMessageItem(
          type: ChatMessageType.outgoing,
          text: "If you're as fun in person as your profile, I'm in.",
          time: '1:04 PM',
          senderImageUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
        ),
        ChatMessageItem(
          type: ChatMessageType.gift,
          giftName: 'Rose',
          giftCoins: 10,
          giftNote: 'A little something to brighten your day 🌹',
        ),
      ],
    );
  }

  static ChatDetailData get aanya =>
      detailFor(SampleChats.conversations.first);
}
