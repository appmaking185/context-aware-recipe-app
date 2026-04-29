import 'package:permission_handler/permission_handler.dart';

class AppPermissionsService {
  AppPermissionsService._();

  static Future<bool> requestLocationPermission() async {
    return isPermissionGranted(await Permission.locationWhenInUse.request());
  }

  static Future<bool> requestNotificationPermission() async {
    return isPermissionGranted(await Permission.notification.request());
  }

  static Future<bool> openSettings() {
    return openAppSettings();
  }

  static bool isPermissionGranted(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.limited:
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.provisional:
        return false;
    }
  }
}
