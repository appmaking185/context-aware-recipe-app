import 'package:flutter/material.dart';

enum ChatFilter { all, unread, online, nearby, dateInvites }

class NewMatch {
  const NewMatch({
    required this.name,
    required this.imageUrl,
    this.isNew = false,
    this.hasVideo = false,
    this.hasBoost = false,
  });

  final String name;
  final String imageUrl;
  final bool isNew;
  final bool hasVideo;
  final bool hasBoost;
}

class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.matchPercent,
    required this.lastMessage,
    required this.timestamp,
    required this.progress,
    required this.progressLabel,
    this.isFromMe = false,
    this.isTyping = false,
    this.isOnline = false,
    this.unreadCount = 0,
    this.progressColor,
    this.giftUnlocked = false,
  });

  final String id;
  final String name;
  final int age;
  final String imageUrl;
  final int matchPercent;
  final String lastMessage;
  final String timestamp;
  final double progress;
  final String progressLabel;
  final bool isFromMe;
  final bool isTyping;
  final bool isOnline;
  final int unreadCount;
  final Color? progressColor;
  final bool giftUnlocked;
}

class ChatDetailData {
  const ChatDetailData({
    required this.conversation,
    required this.level,
    required this.relationshipProgress,
    required this.milestoneText,
    required this.giftCount,
    required this.dateInviteCount,
    required this.venueName,
    required this.messages,
    this.tier = 'PLATINUM',
  });

  final ChatConversation conversation;
  final int level;
  final double relationshipProgress;
  final String milestoneText;
  final int giftCount;
  final int dateInviteCount;
  final String venueName;
  final List<ChatMessageItem> messages;
  final String tier;
}

enum ChatMessageType { system, outgoing, gift }

class ChatMessageItem {
  const ChatMessageItem({
    required this.type,
    this.text,
    this.time,
    this.giftName,
    this.giftCoins,
    this.giftNote,
    this.senderImageUrl,
  });

  final ChatMessageType type;
  final String? text;
  final String? time;
  final String? giftName;
  final int? giftCoins;
  final String? giftNote;
  final String? senderImageUrl;
}
