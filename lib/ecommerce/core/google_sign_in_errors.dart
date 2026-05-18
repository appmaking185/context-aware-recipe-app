/// Maps Google Sign-In / Firebase auth errors to user-readable text.
class GoogleSignInErrors {
  GoogleSignInErrors._();

  /// Example SHA-1 format Firebase accepts (with colons). Must match the keystore
  /// you build with — verify with: `cd android && gradlew signingReport`
  static const exampleSha1Format =
      '8C:23:DA:C0:47:D1:4F:C7:AA:14:50:6F:0D:D3:D7:EE:E0:C1:8D:E4';

  static String mapError(Object error) {
    final text = error.toString();
    if (_isDeveloperError(text)) {
      return 'Google Sign-In failed (Error 10 — developer / SHA-1).\n\n'
          'Checklist:\n'
          '• Firebase → Project settings → Android app '
          '`com.flutter_push_notification`\n'
          '• SHA-1 fingerprints must include the one from YOUR build machine:\n'
          '    cd android\n'
          '    gradlew signingReport   (Windows: gradlew.bat signingReport)\n'
          '  Copy SHA-1 from Variant: debug — format like:\n'
          '    $exampleSha1Format\n'
          '• After adding SHA-1, download a fresh google-services.json into '
          'android/app/\n'
          '• Authentication → Sign-in method → Google → Enabled\n'
          '• flutter clean && flutter run\n\n'
          'If you use another PC or CI, add that debug SHA-1 too.';
    }
    if (text.contains('AuthCancelledException')) {
      return 'Sign-in cancelled.';
    }
    return text
        .replaceFirst('Exception: ', '')
        .replaceFirst('PlatformException(', '');
  }

  static bool _isDeveloperError(String text) {
    return text.contains('ApiException: 10') ||
        (text.contains('sign_in_failed') && text.contains(': 10'));
  }
}
