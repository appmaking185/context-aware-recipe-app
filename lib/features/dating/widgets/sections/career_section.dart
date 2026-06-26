import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/dating_constants.dart';
import '../../models/profile_model.dart';
import '../../theme/dating_colors.dart';
import '../../theme/dating_text_styles.dart';
import '../common/profile_detail_row.dart';
import '../common/section_header.dart';

class CareerSection extends StatelessWidget {
  const CareerSection({
    super.key,
    required this.items,
    this.bigDream,
    this.dreamHeader = 'Her Big Dream',
  });

  final List<CareerItem> items;
  final String? bigDream;
  final String dreamHeader;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Career & Ambition'),
        Container(
          decoration: BoxDecoration(
            color: DatingColors.cardWhite,
            borderRadius: DatingConstants.sectionRadius,
            boxShadow: DatingConstants.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(items.length, (index) {
                final item = items[index];
                return Column(
                  children: [
                    ProfileDetailRow(
                      icon: item.icon,
                      label: item.label,
                      value: item.value,
                      subValue: item.subValue,
                      valueStyle: item.isAllCaps
                          ? DatingTextStyles.ambitionCaps
                          : null,
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
              if (bigDream != null) ...[
                Divider(
                  height: 1,
                  thickness: 1,
                  color: DatingColors.divider,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dreamHeader.toUpperCase(),
                        style: DatingTextStyles.sectionHeader,
                      ),
                      SizedBox(height: 10.h),
                      Text(bigDream!, style: DatingTextStyles.dreamBody),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
