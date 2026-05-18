import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ivtexsolutionsapp/core/logger.dart';
import 'package:ivtexsolutionsapp/ecommerce/core/ecommerce_constants.dart';
import 'package:flutter/services.dart';
import 'package:ivtexsolutionsapp/ecommerce/core/firebase_google_config.dart';
import 'package:ivtexsolutionsapp/ecommerce/core/google_sign_in_errors.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/models/app_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Google Sign-In v6 (classic API) — avoids Android Credential Manager
/// `GetCredentialResponse error` on Oppo / OnePlus and similar devices.
class EcommerceAuthService {
  EcommerceAuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    SharedPreferences? prefs,
  })  : _injectedAuth = firebaseAuth,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              serverClientId: FirebaseGoogleConfig.serverClientId,
              scopes: const ['email', 'profile', 'openid'],
            ),
        _prefs = prefs;

  final FirebaseAuth? _injectedAuth;
  final GoogleSignIn _googleSignIn;
  SharedPreferences? _prefs;

  static const _stepTimeout = Duration(seconds: 90);

  FirebaseAuth? get _auth {
    if (_injectedAuth != null) return _injectedAuth;
    try {
      if (Firebase.apps.isEmpty) return null;
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;
  }

  Stream<User?> authStateChanges() =>
      _auth?.authStateChanges() ?? Stream<User?>.empty();

  AppUserModel? get currentUser {
    final user = _auth?.currentUser;
    if (user == null) return null;
    return _mapUser(user);
  }

  Future<AppUserModel?> loadPersistedSession() async {
    final raw = _prefs?.getString(EcommerceConstants.sessionKey);
    if (raw != null) {
      try {
        return AppUserModel.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      } catch (_) {
        // ignore corrupt cache
      }
    }
    try {
      final user = _auth?.currentUser;
      if (user == null) return null;
      return _mapUser(user);
    } catch (_) {
      return null;
    }
  }

  void _log(String message) {
    logger.i('[GoogleAuth] $message');
    if (kDebugMode) {
      debugPrint('[GoogleAuth] $message');
    }
  }

  Future<AppUserModel> signInWithGoogle() async {
    final auth = _auth;
    if (auth == null) {
      throw Exception(
        'Firebase did not start. Run: flutter clean && flutter run\n'
        'Enable Google sign-in in Firebase Console → Authentication.',
      );
    }

    _log('Starting sign-in (Google Sign-In v6)…');

    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    GoogleSignInAccount? googleUser;
    try {
      _log('Opening Google account picker…');
      googleUser = await _googleSignIn.signIn().timeout(_stepTimeout);
    } on PlatformException catch (e) {
      _log('PlatformException: ${e.code} — ${e.message}');
      throw Exception(GoogleSignInErrors.mapError(e));
    } on TimeoutException {
      throw Exception('Google sign-in timed out. Please try again.');
    }

    if (googleUser == null) {
      _log('User cancelled account picker');
      throw const AuthCancelledException();
    }

    _log('Account selected: ${googleUser.email}');

    final googleAuth = await googleUser.authentication.timeout(
      const Duration(seconds: 30),
    );

    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;
    _log(
      'tokens — idToken: ${idToken != null && idToken.isNotEmpty}, '
      'accessToken: ${accessToken != null}',
    );

    if (idToken == null || idToken.isEmpty) {
      throw Exception(
        'Google did not return an ID token.\n'
        'Firebase Console → Project settings → Android app → add debug SHA-1:\n'
        '  cd android && gradlew signingReport\n'
        'Then download new google-services.json and rebuild.',
      );
    }

    try {
      _log('Signing in to Firebase…');
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );
      final userCredential = await auth
          .signInWithCredential(credential)
          .timeout(const Duration(seconds: 30));
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Firebase returned no user after Google sign-in.');
      }

      final appUser = _mapUser(user);
      await _persistSession(appUser);
      _log('Firebase sign-in OK: ${appUser.email}');
      return appUser;
    } on FirebaseAuthException catch (e) {
      _log('FirebaseAuthException: ${e.code} — ${e.message}');
      throw Exception(
        'Firebase auth failed (${e.code}): ${e.message ?? 'Unknown'}',
      );
    } on TimeoutException {
      throw Exception('Firebase sign-in timed out. Check internet connection.');
    }
  }

  Future<void> signOut() async {
    _log('Signing out…');
    try {
      await _googleSignIn.disconnect();
    } catch (_) {
      try {
        await _googleSignIn.signOut();
      } catch (_) {}
    }
    await _auth?.signOut();
    await _prefs?.remove(EcommerceConstants.sessionKey);
    _log('Sign-out complete — session cleared');
  }

  Future<void> _persistSession(AppUserModel user) async {
    await _prefs?.setString(
      EcommerceConstants.sessionKey,
      jsonEncode(user.toJson()),
    );
  }

  AppUserModel _mapUser(User user) {
    return AppUserModel(
      uid: user.uid,
      displayName: user.displayName ?? 'User',
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );
  }
}

class AuthCancelledException implements Exception {
  const AuthCancelledException();
}
