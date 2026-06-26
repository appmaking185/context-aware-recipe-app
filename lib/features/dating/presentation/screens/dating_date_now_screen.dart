import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/sample_date_now.dart';
import '../../models/date_now_model.dart';
import '../../widgets/date_now/date_now_widgets.dart';

class DatingDateNowScreen extends StatefulWidget {
  const DatingDateNowScreen({super.key});

  @override
  State<DatingDateNowScreen> createState() => _DatingDateNowScreenState();
}

class _DatingDateNowScreenState extends State<DatingDateNowScreen> {
  int _filterIndex = 0;
  int _eventIndex = 0;

  static const _dayLabels = ['TODAY', 'TOMORROW', 'WEEKEND'];

  DateNowEvent get _currentEvent {
    final events = SampleDateNow.events;
    return events[_eventIndex % events.length];
  }

  void _onSkip() {
    setState(() {
      _eventIndex = (_eventIndex + 1) % SampleDateNow.events.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DateNowHeader(),
        DateFilterTabs(
          labels: SampleDateNow.filterLabels,
          selectedIndex: _filterIndex,
          onSelected: (index) => setState(() => _filterIndex = index),
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                DateEventCard(
                  event: _currentEvent,
                  dayLabel: _dayLabels[_filterIndex],
                ),
                DateActionButtons(
                  onSkip: _onSkip,
                  onRequest: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
