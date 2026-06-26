import '../models/date_now_model.dart';

class SampleDateNow {
  SampleDateNow._();

  static const filterLabels = ['Today', 'Tomorrow', 'Weekend'];

  static const events = [
    DateNowEvent(
      id: '1',
      title: 'Pasta & Honest Chats',
      description: 'Foodie looking for a dinner buddy 🍝',
      imageUrl:
          'https://images.unsplash.com/photo-1476124369801-bbc257ff66df?w=800&q=80',
      venue: 'Olive Bar, Mahalaxmi',
      distance: '3.4 km away',
      time: '8:30 PM',
      eventType: 'Dinner',
      matchPercent: 88,
      spotsLabel: 'Just 1',
      payLabel: "I'll pay",
      hostName: 'Ananya',
      hostAge: 25,
      hostImageUrl:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200&q=80',
      hostPronouns: 'she/her',
      hostTag: 'Foodie',
    ),
    DateNowEvent(
      id: '2',
      title: 'Sunset Walk & Chai',
      description: 'Evening stroll by the waterfront ☕',
      imageUrl:
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800&q=80',
      venue: 'Marine Drive',
      distance: '5.1 km away',
      time: '6:00 PM',
      eventType: 'Walk',
      matchPercent: 91,
      spotsLabel: 'Just 1',
      payLabel: 'Split bill',
      hostName: 'Riya',
      hostAge: 24,
      hostImageUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
      hostPronouns: 'she/her',
      hostTag: 'Explorer',
    ),
  ];
}
