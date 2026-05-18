import 'package:ivtexsolutionsapp/core/logger.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/models/app_user_model.dart';

class AuthUserLogger {
  AuthUserLogger._();

  static void logSignedIn(AppUserModel user, {required String source}) {
    logger.i(
      '[$source] Google sign-in success\n'
      '  uid: ${user.uid}\n'
      '  name: ${user.displayName}\n'
      '  email: ${user.email}\n'
      '  photoUrl: ${user.photoUrl ?? '—'}',
    );
  }

  static void logSignedOut({String? uid, String? email}) {
    logger.i(
      '[Auth] User signed out'
      '${uid != null ? '\n  uid: $uid' : ''}'
      '${email != null ? '\n  email: $email' : ''}',
    );
  }

  static void logSessionRestored(AppUserModel user) {
    logger.i(
      '[Auth] Session restored\n'
      '  uid: ${user.uid}\n'
      '  name: ${user.displayName}\n'
      '  email: ${user.email}',
    );
  }
}
