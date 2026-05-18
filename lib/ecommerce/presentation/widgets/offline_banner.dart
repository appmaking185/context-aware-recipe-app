import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/connectivity_provider.dart';
import 'package:ivtexsolutionsapp/resources/app_colors.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final online = context.watch<ConnectivityProvider>().isOnline;
    if (online) return const SizedBox.shrink();

    return MaterialBanner(
      content: const Text('No internet connection'),
      leading: const Icon(Icons.wifi_off, color: AppColors.alertcolor),
      actions: [
        TextButton(
          onPressed: () => context.read<ConnectivityProvider>().refresh(),
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
