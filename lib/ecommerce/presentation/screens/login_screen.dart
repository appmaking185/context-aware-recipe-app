import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ivtexsolutionsapp/ecommerce/presentation/providers/auth_provider.dart';
import 'package:ivtexsolutionsapp/resources/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _onGoogleSignIn(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    await auth.signInWithGoogle();
    // AuthGate redirects to Dashboard when status == authenticated.
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isSigningIn = auth.status == AuthStatus.loading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(
                Icons.shopping_bag_outlined,
                size: 72,
                color: AppColors.appColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'E-Commerce Shop',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Flutter E-Commerce Interview Task',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textColor757575),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: isSigningIn ? null : () => _onGoogleSignIn(context),
                icon: isSigningIn
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.login),
                label: Text(
                  isSigningIn ? 'Signing in...' : 'Sign in with Google',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.appColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: isSigningIn ? null : () => auth.enterAsGuest(),
                child: const Text('Skip — continue as guest'),
              ),
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  auth.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.alertcolor),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
