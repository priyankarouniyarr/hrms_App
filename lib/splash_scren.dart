import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/location%20.dart';
import 'package:hrms_app/screen/onboardscreen.dart';
import 'package:hrms_app/screen/app_main_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/providers/notifications/notification_provider.dart';
import 'package:hrms_app/providers/login_screen_provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _errorMessage;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    // PushNotificationManager.sendNotification(
    //     deviceToken:
    //         "fXHE28MqRWKBzpIDY46zFz:APA91bHgb4IeJiJuthr5J-Fb_wfnvp6Fm6wOJ5rCKTEq32vxMeEZO-6Vytgf0VZnqDn1ui7xoKa56401zetEhNUgUgPBEJrHM04LcfeSC0puPrGdFQ9O2Ks",
    //     message: "Hello from Flutter");
    _initApp();
  }

  Future<void> _initApp() async {
    await LocationService.handleLocationPermission();

    await _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final fcmNotificationProvider =
          Provider.of<FcmnotificationProvider>(context, listen: false);

      await authProvider.loadToken();
      await authProvider.loadUsername();
      await authProvider.loadRefreshToken();
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $fcmToken");
      final hosptialcode = HosptialCodeStorage();
      String? applicationId = await hosptialcode.getHospitalCode();

      bool isLoggedIn = false;
      if (authProvider.token != null) {
        bool isTokenExpired = authProvider.isTokenExpired();
        print("Token expired: $isTokenExpired");

        if (isTokenExpired) {
          print("isTokenExpired: $isTokenExpired");
          try {
            await authProvider.refreshAccessToken(
              context,
            );
            isLoggedIn = true;
          } catch (e) {
            print("Error refreshing token: $e");

            return;
          }
        } else {
          isLoggedIn = true;
        }
      }

      if (isLoggedIn) {
        print("isLoggedIn44: $isLoggedIn");
        if (fcmToken != null && applicationId != null) {
          await fcmNotificationProvider.sendFcmTokenToServer(
              fcmToken, applicationId);
        }
      } else {
        //  ✅ Send FCM token as anonymous (not logged in)
        if (fcmToken != null && applicationId == null) {
          await fcmNotificationProvider.sendFcmDeviceTokenPostAnonymous(
              fcmToken, applicationId ?? '');
        }
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? AppMainScreen() : OnboardScreen(),
        ),
      );
    } catch (e) {
      print("Error : $e");
    }
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
              : Image.asset('assets/logo/logo.jpeg', height: 100),
        ),
      ),
    );
  }
}
