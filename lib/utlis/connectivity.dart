import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHandler {
  bool _isLoading = false;
  bool _isCheckingConnected = true;
  bool _dialogShown = false;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final GlobalKey<NavigatorState> navigatorKey;

  ConnectivityHandler({required this.navigatorKey});

  bool get isLoading => _isLoading;
  bool get isCheckingConnected => _isCheckingConnected;

  void init(Function(void Function()) setState, VoidCallback onUpdate) {
    _initConnectivity(setState, onUpdate);
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
        (results) => _updateConnectionStatus(results, setState, onUpdate));
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }

  Future<void> _initConnectivity(
      Function(void Function()) setState, VoidCallback onUpdate) async {
    setState(() {
      _isCheckingConnected = true;
    });

    List<ConnectivityResult> results;
    try {
      results = await Connectivity().checkConnectivity();
    } catch (e) {
      print("Error checking connectivity: $e");
      results = [ConnectivityResult.none];
    }

    await _updateConnectionStatus(results, setState, onUpdate);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results,
      Function(void Function()) setState, VoidCallback onUpdate) async {
    final hasConnection = results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);

    setState(() {
      _isLoading = hasConnection;
      _isCheckingConnected = false;
    });

    onUpdate();

    if (!hasConnection && !_dialogShown) {
      _dialogShown = true;
      Future.delayed(Duration.zero, () {
        if (navigatorKey.currentContext != null) {
          showDialog(
            barrierColor: Colors.black54,
            barrierDismissible: false,
            context: navigatorKey.currentContext!,
            builder: (context) => AlertDialog(
              title: Padding(
                padding: const EdgeInsets.all(15.0),
                child: const Text('No Internet Connection'),
              ),
              content: const Text(
                  'Please check your internet connection and try again.'),
              actions: const [],
            ),
          );
        }
      });
    } else if (hasConnection && _dialogShown) {
      if (navigatorKey.currentContext != null) {
        Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
      }
      _dialogShown = false;
    }
  }
}
