import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Uses [Connectivity] only. Avoids [InternetConnectionChecker], which often
/// reports false offline on real devices (DNS, captive portals, IPv6, etc.).
class ConnectivityService {
  ConnectivityService();

  final Connectivity _connectivity = Connectivity();

  Stream<bool> get onConnectivityChanged async* {
    yield await hasConnection;
    await for (final _ in _connectivity.onConnectivityChanged) {
      yield await hasConnection;
    }
  }

  Future<bool> get hasConnection async {
    final result = await _connectivity.checkConnectivity();
    return _hasUsableConnection(result);
  }

  bool _hasUsableConnection(List<ConnectivityResult> result) {
    if (result.isEmpty) return true;
    return result.any(_isOnlineTransport);
  }

  bool _isOnlineTransport(ConnectivityResult r) {
    return r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn ||
        r == ConnectivityResult.other;
  }
}
