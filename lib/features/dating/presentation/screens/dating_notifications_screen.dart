import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/sample_notifications.dart';
import '../../models/notification_model.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';
import '../../widgets/notifications/notification_widgets.dart';

class DatingNotificationsScreen extends StatefulWidget {
  const DatingNotificationsScreen({super.key});

  @override
  State<DatingNotificationsScreen> createState() =>
      _DatingNotificationsScreenState();
}

class _DatingNotificationsScreenState extends State<DatingNotificationsScreen> {
  int _filterIndex = 0;
  late List<AppNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.of(SampleNotifications.all);
  }

  List<AppNotification> get _filtered {
    switch (_filterIndex) {
      case 1:
        return _notifications
            .where((n) =>
                n.type == NotificationType.rose ||
                n.type == NotificationType.compliment)
            .toList();
      case 2:
        return _notifications
            .where((n) => n.type == NotificationType.match)
            .toList();
      case 3:
        return _notifications
            .where((n) => n.type == NotificationType.rose)
            .toList();
      case 4:
        return _notifications
            .where((n) => n.type == NotificationType.dateApproved)
            .toList();
      default:
        return _notifications;
    }
  }

  int get _unreadCount => _notifications.where((n) => n.isUnread).length;

  void _markAllRead() {
    setState(() {
      _notifications = _notifications
          .map((n) => AppNotification(
                id: n.id,
                type: n.type,
                title: n.title,
                subtitle: n.subtitle,
                quote: n.quote,
                timestamp: n.timestamp,
                actionLabel: n.actionLabel,
                imageUrl: n.imageUrl,
                name: n.name,
                age: n.age,
                isUnread: false,
                section: n.section,
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sections = <String, List<AppNotification>>{};
    for (final n in _filtered) {
      sections.putIfAbsent(n.section, () => []).add(n);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: DatingColors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationsHeader(
                newCount: _unreadCount,
                onBack: () => Navigator.of(context).pop(),
                onMarkAllRead: _markAllRead,
              ),
              SizedBox(height: 16.h),
              NotificationFilterChips(
                labels: SampleNotifications.filterLabels,
                totalCount: SampleNotifications.totalCount,
                selectedIndex: _filterIndex,
                onSelected: (index) => setState(() => _filterIndex = index),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 16.h),
                  children: [
                    for (final entry in sections.entries) ...[
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
                        child: Text(
                          entry.key,
                          style: DatingTextStyles.sectionHeader.copyWith(
                            color: DatingColors.textSecondary,
                          ),
                        ),
                      ),
                      ...entry.value.map(
                        (n) => NotificationTile(notification: n),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void openNotificationsScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const DatingNotificationsScreen(),
    ),
  );
}
