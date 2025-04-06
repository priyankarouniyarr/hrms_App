import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/screen/onboardscreen.dart';
import 'package:hrms_app/screen/app_main_screen.dart';
import 'package:hrms_app/providers/login_screen_provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () {
      _checkLoginState();
    });
  }

  Future<void> _checkLoginState() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadToken();
    await authProvider.loadUsername();
    await authProvider.loadRefreshToken();

    bool isLoggedIn = false;
    if (authProvider.token != null) {
      bool isTokenExpired = await authProvider.isTokenExpired();
      if (isTokenExpired) {
        await authProvider.refreshAccessToken();
        isLoggedIn = true;
      } else {
        isLoggedIn = true;
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isLoggedIn ? AppMainScreen() : OnboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Image.asset('assets/logo/logo.jpeg'), // Your logo path
        ),
      ),
    );
  }
}
