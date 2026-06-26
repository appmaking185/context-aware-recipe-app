class ComplimentCategory {
  const ComplimentCategory({
    required this.name,
    required this.ideas,
  });

  final String name;
  final List<String> ideas;
}

class SampleComplimentIdeas {
  SampleComplimentIdeas._();

  static const categories = [
    ComplimentCategory(
      name: 'Sweet',
      ideas: [
        'Your energy feels so warm — I had to say hi.',
        'You seem like someone who makes ordinary days feel special.',
        'There is something really genuine about your profile.',
      ],
    ),
    ComplimentCategory(
      name: 'Playful',
      ideas: [
        'Not gonna lie, your smile stopped my scroll 😍',
        "You're trouble, I can already tell — the good kind.",
        "I think we'd make a dangerously good team ☕️➡️🍷",
      ],
    ),
    ComplimentCategory(
      name: 'Admiring',
      ideas: [
        "You've got a vibe I can't quite look away from.",
        'The way you present yourself is effortlessly cool.',
        'Your profile reads like someone who knows what they want.',
      ],
    ),
    ComplimentCategory(
      name: 'Flirty',
      ideas: [
        'Not gonna lie, your smile stopped my scroll 😍',
        "You're trouble, I can already tell — the good kind.",
        "If you're as fun in person as your profile, I'm in.",
        "I think we'd make a dangerously good team ☕️➡️🍷",
        "You've got a vibe I can't quite look away from.",
        'Coffee, you, and good conversation — when\'s good for you?',
      ],
    ),
    ComplimentCategory(
      name: 'First date',
      ideas: [
        'Coffee, you, and good conversation — when\'s good for you?',
        'Your profile made me curious — free for a quick coffee this week?',
        'You seem fun. Want to test that theory over chai sometime?',
      ],
    ),
  ];
}
