import 'package:flutter/material.dart';

enum NotificationType { rose, compliment, match, message, dateApproved }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.quote,
    required this.timestamp,
    this.actionLabel,
    this.imageUrl,
    this.name,
    this.age,
    this.isUnread = true,
    this.section = 'TODAY',
  });

  final String id;
  final NotificationType type;
  final String title;
  final String? subtitle;
  final String? quote;
  final String timestamp;
  final String? actionLabel;
  final String? imageUrl;
  final String? name;
  final int? age;
  final bool isUnread;
  final String section;
}
