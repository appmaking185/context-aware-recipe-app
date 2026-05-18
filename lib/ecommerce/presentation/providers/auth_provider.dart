import 'package:flutter/foundation.dart';
import 'package:ivtexsolutionsapp/core/logger.dart';
import 'package:ivtexsolutionsapp/ecommerce/core/auth_user_logger.dart';
import 'package:ivtexsolutionsapp/ecommerce/core/google_sign_in_errors.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/models/app_user_model.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/ecommerce_auth_service.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  guest,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService);

  final EcommerceAuthService _authService;

  AuthStatus status = AuthStatus.initial;
  AppUserModel? user;
  String? errorMessage;
  bool isBootstrapping = true;

  /// True once after Google sign-in — dashboard shows welcome then clears.
  bool showWelcomeAfterLogin = false;

  bool get isGuest => status == AuthStatus.guest;

  Future<void> bootstrap() async {
    isBootstrapping = true;
    status = AuthStatus.loading;
    notifyListeners();

    user = await _authService.loadPersistedSession() ?? _authService.currentUser;
    if (user != null) {
      AuthUserLogger.logSessionRestored(user!);
    }
    status = user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    isBootstrapping = false;
    notifyListeners();
  }

  void enterAsGuest() {
    user = null;
    errorMessage = null;
    showWelcomeAfterLogin = false;
    status = AuthStatus.guest;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    status = AuthStatus.loading;
    errorMessage = null;
    showWelcomeAfterLogin = false;
    notifyListeners();

    logger.i('[AuthProvider] signInWithGoogle started');
    try {
      user = await _authService.signInWithGoogle();
      AuthUserLogger.logSignedIn(user!, source: 'Google');
      status = AuthStatus.authenticated;
      showWelcomeAfterLogin = true;
      logger.i('[AuthProvider] signInWithGoogle success → dashboard');
    } on AuthCancelledException {
      logger.i('[AuthProvider] sign-in cancelled by user');
      status = AuthStatus.unauthenticated;
      errorMessage = null;
    } catch (e, st) {
      logger.e('[AuthProvider] signInWithGoogle failed: $e\n$st');
      status = AuthStatus.unauthenticated;
      errorMessage = GoogleSignInErrors.mapError(e);
    }
    notifyListeners();
  }

  void clearWelcomeAfterLogin() {
    if (!showWelcomeAfterLogin) return;
    showWelcomeAfterLogin = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    final uid = user?.uid;
    final email = user?.email;
    await _authService.signOut();
    AuthUserLogger.logSignedOut(uid: uid, email: email);
    user = null;
    showWelcomeAfterLogin = false;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
