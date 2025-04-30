import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/screen/onboardscreen.dart';
import 'package:hrms_app/storage/token_storage.dart';
import 'package:hrms_app/screen/app_main_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hrms_app/providers/login_screen_provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String status = "Waiting";
  String? _errorMessage;
  Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    checkRealTimeConnectivity(); // Setup real-time listener
    TokenStorage().getfcmDeviceTokenPostAnynomus(context);
    _checkInternetAndProceed(); // Check internet and proceed accordingly
  }

  void checkRealTimeConnectivity() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        status = "MobileData";
        print("Connected to mobile network");
      } else if (event == ConnectivityResult.wifi) {
        status = "Wifi";
        print("Connected to wifi network");
      } else {
        status = "Non-Connection";
        print("Not connected to any network");
      }
      setState(() {});
    });
  }

  Future<void> _checkInternetAndProceed() async {
    final connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      print("connectivityResult:$connectivityResult");
      print("login sucess");
      print("Internet connection available. Proceeding to check login state.");
      // Internet is available
      Timer(Duration(seconds: 2), () {
        _checkLoginState();
      });
    } else {
      // No internet connection
      print("No internet connection. Staying on splash screen.");
    }
  }

  Future<void> _checkLoginState() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.loadToken();
      await authProvider.loadUsername();
      await authProvider.loadRefreshToken();

      bool isLoggedIn = false;
      if (authProvider.token != null) {
        bool isTokenExpired = authProvider.isTokenExpired();
        print("Token expired: $isTokenExpired");

        if (isTokenExpired) {
          await authProvider.refreshAccessToken();
        }
        isLoggedIn = true;
      }

      if (isLoggedIn) {
        TokenStorage().getfcmToken(context);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? AppMainScreen() : OnboardScreen(),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        print("Error: $_errorMessage");
      });
    }
  }

  @override
  void dispose() {
    _streamSubscription.cancel(); // Clean up listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: _errorMessage != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'Error occurred:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                )
              : Image.asset('assets/logo/logo.jpeg'),
        ),
      ),
    );
  }
}
