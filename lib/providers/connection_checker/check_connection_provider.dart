import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CheckNetworkProvider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  CheckNetworkProvider() {
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen((results) {
      _updateConnectionStatus(results);
    });
  }

  Future<void> _initConnectivity() async {
    try {
      var results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      debugPrint("Couldn't check connectivity: $e");
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    bool wasConnected = _isConnected;
    _isConnected = results.isNotEmpty &&
        results.any((result) => result != ConnectivityResult.none);

    if (!_isConnected) {
      debugPrint('No internet connection');
    } else if (!wasConnected) {
      debugPrint('Internet connection restored');
    }

    notifyListeners();
  }
}
