import 'package:flutter/material.dart';

import '../models/profile_model.dart';

class SampleProfiles {
  SampleProfiles._();

  static const _basics = [
    BasicsItem(
      icon: Icons.cake_outlined,
      label: 'Age',
      value: '21 years old',
      subValue: '19 feb 1999',
    ),
    BasicsItem(
      icon: Icons.straighten_outlined,
      label: 'Height',
      value: "5'5\" (165 cm)",
    ),
    BasicsItem(
      icon: Icons.location_on_outlined,
      label: 'Lives in',
      value: 'Koregaon park',
      subValue: 'Pune, Maharashtra',
    ),
    BasicsItem(
      icon: Icons.favorite_border,
      label: 'Love language',
      value: 'Compliment',
      subValue: 'Words of affirmation',
    ),
    BasicsItem(
      icon: Icons.local_fire_department_outlined,
      label: 'Religion',
      value: 'Hindu-Marathi',
    ),
    BasicsItem(
      icon: Icons.people_outline,
      label: 'Interested in',
      value: 'Women - Dating',
    ),
    BasicsItem(
      icon: Icons.wb_sunny_outlined,
      label: 'Zodiac',
      value: 'Scorpio',
      subValue: 'Loyal - Passionate - Intuitive',
    ),
    BasicsItem(
      icon: Icons.translate_outlined,
      label: 'Mother tongue',
      value: 'Marathi',
    ),
    BasicsItem(
      icon: Icons.phone_outlined,
      label: 'Communication style',
      value: 'Phone calls over texts',
    ),
  ];

  static const _career = [
    CareerItem(
      icon: Icons.school_outlined,
      label: 'Education',
      value: 'NIFT Pune',
      subValue: 'B. Des Fashion Design · 3rd year',
    ),
    CareerItem(
      icon: Icons.work_outline,
      label: 'Work as',
      value: 'Fashion Design',
      subValue: 'Freelance · 2 yrs exp',
    ),
    CareerItem(
      icon: Icons.auto_awesome_outlined,
      label: 'Work style',
      value: 'Creative · Hybrid',
    ),
    CareerItem(
      icon: Icons.trending_up,
      label: 'Ambition level',
      value: 'HIGHLY DRIVEN',
      isAllCaps: true,
    ),
  ];

  static const _prompts = [
    ProfilePrompt(
      header: 'The way to win me over is...',
      body: 'A good book rec and a strong chai opinion.',
    ),
    ProfilePrompt(
      header: 'My simple pleasures...',
      body: 'Roadside chai after a long trek, no signal, good company.',
    ),
    ProfilePrompt(
      header: "We'll get along if...",
      body: 'You can debate me for an hour and still want dessert after.',
    ),
  ];

  static const _interests = [
    InterestItem(icon: Icons.flight_outlined, label: 'Travel'),
    InterestItem(icon: Icons.coffee_outlined, label: 'Coffee'),
    InterestItem(icon: Icons.terrain_outlined, label: 'Trekking'),
    InterestItem(icon: Icons.menu_book_outlined, label: 'Books'),
    InterestItem(icon: Icons.self_improvement_outlined, label: 'Yoga'),
    InterestItem(icon: Icons.music_note_outlined, label: 'Indie music'),
    InterestItem(icon: Icons.soup_kitchen_outlined, label: 'Cooking'),
    InterestItem(icon: Icons.camera_alt_outlined, label: 'Photography'),
  ];

  static const _lifestyle = [
    LifestyleItem(
      icon: Icons.restaurant_outlined,
      label: 'Diet',
      value: 'Vegetarian',
    ),
    LifestyleItem(
      icon: Icons.wine_bar_outlined,
      label: 'Drinking',
      value: 'Socially',
    ),
    LifestyleItem(
      icon: Icons.smoke_free_outlined,
      label: 'Smoking',
      value: 'Non-smoker',
    ),
    LifestyleItem(
      icon: Icons.fitness_center_outlined,
      label: 'Fitness',
      value: 'Gym 4x/week',
      subValue: 'Yoga · Trekking',
    ),
    LifestyleItem(
      icon: Icons.flight_takeoff_outlined,
      label: 'Travel',
      value: '4-5 trips/year',
    ),
    LifestyleItem(
      icon: Icons.pets_outlined,
      label: 'Pets',
      value: 'Cat parent',
    ),
    LifestyleItem(
      icon: Icons.nightlight_outlined,
      label: 'Sleep',
      value: 'Night Owl',
    ),
  ];

  static const _datingGoal = DatingGoal(
    title: 'Long-term, marriage-open',
    description:
        'No pressure, no timelines — just looking for the right person '
        'to build something real with.',
  );

  static const String _about =
      'Building products by day, planning my next trek by night. '
      'Looking for someone equally driven and equally curious.';

  static const String _dream =
      'Launch her own sustainable Indian fashion label — handcrafted, '
      'slow fashion made with heart. Also wants to travel every fashion '
      'capital before 30.';

  static List<DatingProfile> get all => [
        DatingProfile(
          id: '1',
          name: 'Shraddha',
          age: 21,
          imageUrl:
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&q=80',
          videoThumbnailUrl:
              'https://images.unsplash.com/photo-1521577352947-9bb58764b69a?w=800&q=80',
          thirdImageUrl:
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800&q=80',
          fourthImageUrl:
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800&q=80',
          location: 'Pune',
          distance: '7 km away',
          occupation: 'Fashion Designer',
          height: "5'4\"",
          intent: 'Serious relationship',
          matchPercent: 74,
          trustPercent: 98,
          replyTime: '~5m Reply',
          about: _about,
          basics: _basics,
          career: _career,
          bigDream: _dream,
          prompts: _prompts,
          interests: _interests,
          lifestyle: _lifestyle,
          datingGoal: _datingGoal,
        ),
        DatingProfile(
          id: '2',
          name: 'Meera',
          age: 26,
          imageUrl:
              'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=800&q=80',
          videoThumbnailUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&q=80',
          thirdImageUrl:
              'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=800&q=80',
          fourthImageUrl:
              'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=800&q=80',
          location: 'Bengaluru',
          distance: '4 km away',
          occupation: 'Product Designer',
          height: "5'5\"",
          intent: "Let's see where it goes",
          matchPercent: 88,
          trustPercent: 98,
          replyTime: '~5m Reply',
          about: _about,
          basics: _basics,
          career: _career,
          bigDream: _dream,
          prompts: _prompts,
          interests: _interests,
          lifestyle: _lifestyle,
          datingGoal: _datingGoal,
        ),
        DatingProfile(
          id: '3',
          name: 'Ishita',
          age: 22,
          imageUrl:
              'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800&q=80',
          videoThumbnailUrl:
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&q=80',
          thirdImageUrl:
              'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=800&q=80',
          fourthImageUrl:
              'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800&q=80',
          location: 'Hyderabad',
          distance: '5 km away',
          occupation: 'Content Creator',
          height: "5'2\"",
          intent: 'Serious relationship',
          matchPercent: 77,
          trustPercent: 98,
          replyTime: '~5m Reply',
          about: _about,
          basics: _basics,
          career: _career,
          bigDream: _dream,
          prompts: _prompts,
          interests: _interests,
          lifestyle: _lifestyle,
          datingGoal: _datingGoal,
        ),
      ];
}
