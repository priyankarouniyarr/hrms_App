import 'package:flutter/material.dart';

Future<void> showSocketErrorDialog({
  required BuildContext context,
  required VoidCallback onRetry,
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
            onPressed: () {
              Navigator.of(context).pop();
              onRetry();
            },
            child: const Text("Retry"),
          ),
        ],
      );
    },
  );
}
