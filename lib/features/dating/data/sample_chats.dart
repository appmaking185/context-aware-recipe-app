import 'package:flutter/material.dart';

import '../models/chat_model.dart';

class SampleChats {
  SampleChats._();

  static const newMatches = [
    NewMatch(
      name: 'Sarah',
      imageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80',
      isNew: true,
    ),
    NewMatch(
      name: 'Ariya',
      imageUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
      hasBoost: true,
    ),
    NewMatch(
      name: 'Liam',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
    ),
    NewMatch(
      name: 'Chloe',
      imageUrl:
          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200&q=80',
      hasVideo: true,
    ),
    NewMatch(
      name: 'Dev',
      imageUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&q=80',
    ),
  ];

  static const conversations = [
    ChatConversation(
      id: '1',
      name: 'Aanya',
      age: 25,
      imageUrl:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200&q=80',
      matchPercent: 92,
      lastMessage: 'Funny you mention that — I was just...',
      timestamp: '2m',
      isOnline: true,
      progress: 1.0,
      progressLabel: 'Gift unlocked!',
      progressColor: Color(0xFF4CD964),
      giftUnlocked: true,
      unreadCount: 2,
    ),
    ChatConversation(
      id: '2',
      name: 'Jordan',
      age: 28,
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&q=80',
      matchPercent: 88,
      lastMessage: 'Typing...',
      timestamp: 'Now',
      isOnline: true,
      isTyping: true,
      progress: 0.72,
      progressLabel: '18/25 for Premium Rose 🌹',
      progressColor: Color(0xFFD66B7C),
    ),
    ChatConversation(
      id: '3',
      name: 'Marcus',
      age: 31,
      imageUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&q=80',
      matchPercent: 81,
      lastMessage: 'Want to check out that new rooftop spot?',
      timestamp: '1h',
      progress: 0.2,
      progressLabel: '5/25 - Deadline 14h ⏰',
      progressColor: Color(0xFFE85D5D),
    ),
    ChatConversation(
      id: '4',
      name: 'Elena',
      age: 27,
      imageUrl:
          'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=200&q=80',
      matchPercent: 95,
      lastMessage: "Hey! I'm heading over now.",
      timestamp: '3h',
      isOnline: true,
      isFromMe: true,
      progress: 0.88,
      progressLabel: '22/25 for Silver Ring 💍',
      progressColor: Color(0xFFD66B7C),
    ),
    ChatConversation(
      id: '5',
      name: 'Priya',
      age: 24,
      imageUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&q=80',
      matchPercent: 86,
      lastMessage: 'That sounds amazing, count me in!',
      timestamp: 'Yesterday',
      progress: 0.45,
      progressLabel: '11/25 for Coffee Date ☕',
      progressColor: Color(0xFFD66B7C),
    ),
  ];

  static const filterLabels = [
    'All',
    'Unread',
    'Online',
    'Nearby',
    'Date Invites',
  ];
}
