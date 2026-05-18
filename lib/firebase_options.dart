// Generated from android/app/google-services.json (project: flutterpushnotification-13b72).
// Re-run `flutterfire configure` after changing Firebase apps.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not configured for this project.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'Add GoogleService-Info.plist and run flutterfire configure for iOS.',
        );
      default:
        throw UnsupportedError(
          'Firebase is only configured for Android in this project.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCE-PC6cL7qZI66dNcemL_Y8Oq4h6tYVmY',
    appId: '1:168596957784:android:75047d1336598c9b00f82d',
    messagingSenderId: '168596957784',
    projectId: 'flutterpushnotification-13b72',
    storageBucket: 'flutterpushnotification-13b72.firebasestorage.app',
  );
}
