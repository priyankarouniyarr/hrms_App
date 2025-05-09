import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/providers/connectivity_checker/connectivity_provider.dart';

class ConnectivityListener extends StatefulWidget {
  final Widget child;
  const ConnectivityListener({super.key, required this.child});

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  bool _dialogShown = false;
  late ConnectivityProvider _connectivityProvider;

  @override
  void initState() {
    super.initState();

    _connectivityProvider =
        Provider.of<ConnectivityProvider>(context, listen: false);
    _connectivityProvider.addListener(_onConnectivityChanged);
  }

  @override
  void dispose() {
    _connectivityProvider.removeListener(_onConnectivityChanged);
    super.dispose();
  }

  void _onConnectivityChanged() async {
    if (!_connectivityProvider.isConnected && !_dialogShown) {
      _dialogShown = true;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () async {
                print(
                    "_connectivityPROvioder:${_connectivityProvider.isConnected}");
                _connectivityProvider.retryCheck();
                if (_connectivityProvider.isConnected) {
                  Navigator.of(context).pop();
                  _dialogShown = false;
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (_connectivityProvider.isConnected && _dialogShown) {
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      _dialogShown = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
