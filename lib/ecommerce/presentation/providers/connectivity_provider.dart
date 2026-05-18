import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ivtexsolutionsapp/ecommerce/data/services/connectivity_service.dart';

class ConnectivityProvider extends ChangeNotifier {
  ConnectivityProvider(this._service) {
    _subscription = _service.onConnectivityChanged.listen((online) {
      isOnline = online;
      notifyListeners();
    });
  }

  final ConnectivityService _service;
  StreamSubscription<bool>? _subscription;

  bool isOnline = true;

  Future<void> refresh() async {
    isOnline = await _service.hasConnection;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
