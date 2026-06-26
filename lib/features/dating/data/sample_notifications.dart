import '../models/notification_model.dart';

class SampleNotifications {
  SampleNotifications._();

  static const newUpdatesCount = 9;
  static const totalCount = 56;

  static const filterLabels = [
    'All',
    'Likes & roses',
    'Matches',
    'Gifts',
    'Dates',
  ];

  static const all = [
    AppNotification(
      id: '1',
      type: NotificationType.rose,
      name: 'Dev',
      age: 27,
      title: 'Dev, 27 sent you a Rose',
      quote: 'Your trekking photos sold me — let\'s swap trail stories.',
      timestamp: '12 min ago',
      actionLabel: 'View profile',
      imageUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&q=80',
    ),
    AppNotification(
      id: '2',
      type: NotificationType.compliment,
      name: 'Arjun',
      age: 28,
      title: 'Arjun, 28 complimented your About',
      quote: 'Equally driven and equally curious — that line got me.',
      timestamp: '3 h ago',
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&q=80',
    ),
    AppNotification(
      id: '3',
      type: NotificationType.match,
      name: 'Aanya',
      age: 25,
      title: 'It\'s a match with Aanya, 25',
      subtitle: 'You both liked each other. Say hello before the spark fades.',
      timestamp: '40 min ago',
      actionLabel: 'Send a message',
      imageUrl:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200&q=80',
    ),
    AppNotification(
      id: '4',
      type: NotificationType.message,
      name: 'Elena',
      age: 23,
      title: 'Elena, 23 sent you a message',
      quote: 'Haha okay that café pick was elite. When are you free?',
      timestamp: '1 h ago',
      imageUrl:
          'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=200&q=80',
    ),
    AppNotification(
      id: '5',
      type: NotificationType.dateApproved,
      name: 'Kabir',
      title: 'Kabir approved your date request',
      subtitle: 'Coffee at Blue Tokai · Today, 7:00 PM · Koregaon Park',
      timestamp: '2 h ago',
      actionLabel: 'Open chat',
    ),
  ];
}
