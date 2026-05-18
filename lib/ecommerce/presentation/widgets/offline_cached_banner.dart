import 'package:flutter/material.dart';
import 'package:ivtexsolutionsapp/resources/app_colors.dart';

class OfflineCachedBanner extends StatelessWidget {
  const OfflineCachedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.custYellow.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.custYellow.withValues(alpha: 0.5)),
      ),
      child: const Row(
        children: [
          Icon(Icons.cloud_off, color: AppColors.custYellow, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Offline — showing saved products. Pull down to refresh when online.',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
