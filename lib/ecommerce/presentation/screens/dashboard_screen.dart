import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/location_service.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/auth_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/connectivity_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/location_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/screens/product_list_screen.dart';
import 'package:ivtexsolutionsapp/resources/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      context.read<LocationProvider>().loadLocation();
      if (auth.showWelcomeAfterLogin && auth.user != null && !auth.isGuest) {
        final name = auth.user!.displayName;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome, $name!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        auth.clearWelcomeAfterLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final location = context.watch<LocationProvider>();
    final online = context.watch<ConnectivityProvider>().isOnline;
    final user = auth.user;
    final isGuest = auth.isGuest;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          if (!isGuest)
            TextButton.icon(
              onPressed: () => _confirmLogout(context, auth),
              icon: const Icon(Icons.logout, color: Colors.white, size: 20),
              label: const Text(
                'Log out',
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            IconButton(
              onPressed: () => auth.signOut(),
              tooltip: 'Back to login',
              icon: const Icon(Icons.close),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!online)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.messageErrorBgColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.wifi_off, color: AppColors.alertcolor),
                    SizedBox(width: 8),
                    Expanded(child: Text('You are offline. Some features may be limited.')),
                  ],
                ),
              ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: user?.photoUrl != null
                          ? CachedNetworkImageProvider(user!.photoUrl!)
                          : null,
                      child: user?.photoUrl == null
                          ? const Icon(Icons.person, size: 32)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isGuest
                                ? 'Guest'
                                : (user?.displayName ?? 'User'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            isGuest
                                ? 'Sign in later for full account features'
                                : (user?.email ?? ''),
                            style: const TextStyle(
                              color: AppColors.textColor757575,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.appColor),
                        SizedBox(width: 8),
                        Text(
                          'Current location',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (location.loading)
                      const LinearProgressIndicator()
                    else
                      Text(location.result?.address ?? 'Fetching address...'),
                    if (location.result?.status ==
                        LocationStatus.permanentlyDenied) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: location.openSettings,
                        child: const Text('Open Settings'),
                      ),
                    ],
                    if (location.result?.status ==
                        LocationStatus.serviceDisabled) ...[
                      const SizedBox(height: 4),
                      const Text(
                        'Enable GPS to get accurate address.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProductListScreen(),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.appColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Browse Products'),
            ),
            if (!isGuest) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _confirmLogout(context, auth),
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.alertcolor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, AuthProvider auth) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.alertcolor,
            ),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await auth.signOut();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have been logged out'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
