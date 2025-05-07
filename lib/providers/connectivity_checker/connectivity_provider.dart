import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityProvider() {
    _initConnectivity();
    _subscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    bool newStatus = result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi);
    print(newStatus);
    if (_isConnected != newStatus) {
      _isConnected = newStatus;
      notifyListeners();
    }
  }

  Future<void> _initConnectivity() async {
    try {
      List<ConnectivityResult> results =
          await Connectivity().checkConnectivity();
      _updateConnectionStatus(results);
    } catch (_) {
      _isConnected = false;
      notifyListeners();
    }
  }

  void retryCheck() async {
    await _initConnectivity();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
