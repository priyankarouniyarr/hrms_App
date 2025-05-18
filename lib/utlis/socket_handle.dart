import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> showSocketErrorDialog({
  required BuildContext context,
  required Future<void> Function() onRetry,
}) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Connection Error"),
        content:
            const Text("Unable to connect to the server. Please try again."),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog first
              final connectivityResult =
                  await Connectivity().checkConnectivity();
              final hasConnection =
                  connectivityResult != ConnectivityResult.none;
              if (hasConnection) {
                await onRetry(); // Retry if internet is back
              } else {
                // Show dialog again if still no connection
                await showSocketErrorDialog(context: context, onRetry: onRetry);
              }
            },
            child: const Text("Retry"),
          ),
        ],
      );
    },
  );
}
