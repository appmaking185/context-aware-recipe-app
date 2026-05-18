import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

enum LocationStatus {
  loading,
  granted,
  denied,
  permanentlyDenied,
  serviceDisabled,
  error,
}

class LocationResult {
  final LocationStatus status;
  final String? address;

  const LocationResult({required this.status, this.address});
}

class EcommerceLocationService {
  Future<LocationResult> fetchAddress() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocationResult(
        status: LocationStatus.serviceDisabled,
        address: 'Location services are disabled.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return const LocationResult(
        status: LocationStatus.denied,
        address: 'Location permission denied.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      return const LocationResult(
        status: LocationStatus.permanentlyDenied,
        address: 'Location permission permanently denied. Open settings.',
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
      if (places.isEmpty) {
        return const LocationResult(
          status: LocationStatus.error,
          address: 'Unable to resolve address.',
        );
      }
      final place = places.first;
      final parts = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((e) => e != null && e.trim().isNotEmpty).join(', ');

      return LocationResult(
        status: LocationStatus.granted,
        address: parts.isEmpty ? 'Address unavailable' : parts,
      );
    } catch (_) {
      return const LocationResult(
        status: LocationStatus.error,
        address: 'Failed to fetch location.',
      );
    }
  }

  Future<void> openAppSettings() => ph.openAppSettings();
}
