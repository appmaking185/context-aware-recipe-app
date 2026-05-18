import 'package:flutter/foundation.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  LocationProvider(this._service);

  final EcommerceLocationService _service;

  LocationResult? result;
  bool loading = false;

  Future<void> loadLocation() async {
    loading = true;
    notifyListeners();

    result = await _service.fetchAddress();
    loading = false;
    notifyListeners();
  }

  Future<void> openSettings() => _service.openAppSettings();
}
