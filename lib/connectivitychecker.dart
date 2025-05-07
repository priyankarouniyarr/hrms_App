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

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, provider, _) {
        if (!provider.isConnected && !_dialogShown) {
          _dialogShown = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('Connection Lost'),
                content: const Text(
                    'Your internet connection appears to be offline. Some features may not work properly.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _dialogShown = false;
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          });
        } else if (provider.isConnected && _dialogShown) {
          _dialogShown = false;
          Navigator.of(context, rootNavigator: true).pop();
        }
        return widget.child;
      },
    );
  }
}
