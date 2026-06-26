import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/dating_constants.dart';
import '../../models/profile_model.dart';
import '../../theme/dating_colors.dart';
import '../common/profile_detail_row.dart';
import '../common/section_header.dart';

class BasicsSection extends StatelessWidget {
  const BasicsSection({
    super.key,
    required this.items,
  });

  final List<BasicsItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'The Basics'),
        Container(
          decoration: BoxDecoration(
            color: DatingColors.cardWhite,
            borderRadius: DatingConstants.sectionRadius,
            boxShadow: DatingConstants.softShadow,
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Column(
                children: [
                  ProfileDetailRow(
                    icon: item.icon,
                    label: item.label,
                    value: item.value,
                    subValue: item.subValue,
                  ),
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 52.w,
                      color: DatingColors.divider,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
