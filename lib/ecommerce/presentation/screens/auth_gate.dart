import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/auth_provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/screens/dashboard_screen.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/screens/login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isBootstrapping) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _buildScreen(auth),
    );
  }

  Widget _buildScreen(AuthProvider auth) {
    if (auth.status == AuthStatus.authenticated ||
        auth.status == AuthStatus.guest) {
      return const DashboardScreen(key: ValueKey('dashboard'));
    }

    return const LoginScreen(key: ValueKey('login'));
  }
}
