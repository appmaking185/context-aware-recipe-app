import 'package:flutter/material.dart';

class ProfileBadge {
  const ProfileBadge({
    required this.label,
    required this.dotColor,
  });

  final String label;
  final Color dotColor;
}

class BasicsItem {
  const BasicsItem({
    required this.icon,
    required this.label,
    required this.value,
    this.subValue,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subValue;
}

class CareerItem {
  const CareerItem({
    required this.icon,
    required this.label,
    required this.value,
    this.subValue,
    this.isAllCaps = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subValue;
  final bool isAllCaps;
}

class ProfilePrompt {
  const ProfilePrompt({
    required this.header,
    required this.body,
  });

  final String header;
  final String body;
}

class InterestItem {
  const InterestItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

class LifestyleItem {
  const LifestyleItem({
    required this.icon,
    required this.label,
    required this.value,
    this.subValue,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subValue;
}

class DatingGoal {
  const DatingGoal({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

class DatingProfile {
  const DatingProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.location,
    required this.distance,
    required this.occupation,
    required this.height,
    required this.intent,
    required this.matchPercent,
    required this.trustPercent,
    required this.replyTime,
    required this.about,
    required this.basics,
    required this.career,
    required this.bigDream,
    required this.prompts,
    required this.videoThumbnailUrl,
    required this.interests,
    required this.lifestyle,
    required this.datingGoal,
    this.thirdImageUrl,
    this.fourthImageUrl,
    this.videoIntroDuration = '0:28',
    this.isOnline = true,
    this.isVerified = true,
  });

  final String id;
  final String name;
  final int age;
  /// First image — shown on the top profile card.
  final String imageUrl;
  /// Video thumbnail — shown only in the video intro section.
  final String videoThumbnailUrl;
  /// Third image — shown in the bottom media card.
  final String? thirdImageUrl;
  /// Fourth image — shown after dating goal card.
  final String? fourthImageUrl;
  final String location;
  final String distance;
  final String occupation;
  final String height;
  final String intent;
  final int matchPercent;
  final int trustPercent;
  final String replyTime;
  final String about;
  final List<BasicsItem> basics;
  final List<CareerItem> career;
  final String bigDream;
  final List<ProfilePrompt> prompts;
  final List<InterestItem> interests;
  final List<LifestyleItem> lifestyle;
  final DatingGoal datingGoal;
  final String videoIntroDuration;
  final bool isOnline;
  final bool isVerified;

  List<ProfileBadge> get badges => [
        ProfileBadge(
          label: '$matchPercent% Match',
          dotColor: const Color(0xFF4A9EFF),
        ),
        ProfileBadge(
          label: '$trustPercent% Trust',
          dotColor: const Color(0xFF4CD964),
        ),
        ProfileBadge(
          label: replyTime,
          dotColor: const Color(0xFFFF9F0A),
        ),
      ];
}
