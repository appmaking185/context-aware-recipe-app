import 'dart:ui';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationContextResult {
  final String? country;
  final bool permissionDenied;

  const LocationContextResult({
    required this.country,
    required this.permissionDenied,
  });
}

class LocationContextService {
  Future<LocationContextResult> getCountryContext() async {
    final permissionStatus = await Permission.locationWhenInUse.request();
    final permissionDenied = !permissionStatus.isGranted;

    if (permissionDenied) {
      return LocationContextResult(
        country: PlatformDispatcher.instance.locale.countryCode,
        permissionDenied: true,
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      final places = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final country = places.isNotEmpty
          ? places.first.country
          : PlatformDispatcher.instance.locale.countryCode;

      return LocationContextResult(
        country: country,
        permissionDenied: false,
      );
    } catch (_) {
      return LocationContextResult(
        country: PlatformDispatcher.instance.locale.countryCode,
        permissionDenied: false,
      );
    }
  }
}
