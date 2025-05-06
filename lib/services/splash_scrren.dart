import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hrms_app/services/startup_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(Duration(seconds: 2)); // Optional splash delay
      await StartupService(context).initializeApp();
    } on SocketException {
      _showErrorDialog('No Internet', 'Please check your connection.');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeApp();
            },
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _errorMessage != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 40),
                  SizedBox(height: 10),
                  Text('Error occurred:'),
                  Text(_errorMessage!, textAlign: TextAlign.center),
                ],
              )
            : Image.asset('assets/logo/logo.jpeg', height: 100),
      ),
    );
  }
}
