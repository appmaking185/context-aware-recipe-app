class DateNowEvent {
  const DateNowEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.venue,
    required this.distance,
    required this.time,
    required this.eventType,
    required this.matchPercent,
    required this.spotsLabel,
    required this.payLabel,
    required this.hostName,
    required this.hostAge,
    required this.hostImageUrl,
    required this.hostPronouns,
    required this.hostTag,
    this.isLive = true,
    this.isVerified = true,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String venue;
  final String distance;
  final String time;
  final String eventType;
  final int matchPercent;
  final String spotsLabel;
  final String payLabel;
  final String hostName;
  final int hostAge;
  final String hostImageUrl;
  final String hostPronouns;
  final String hostTag;
  final bool isLive;
  final bool isVerified;
}
