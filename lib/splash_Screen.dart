import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms_app/screen/onboardscreen.dart';
import 'package:hrms_app/storage/token_storage.dart';
import 'package:hrms_app/screen/app_main_screen.dart';
import 'package:hrms_app/providers/login_screen_provider/auth_provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _errorMessage;
  late StreamSubscription<InternetConnectionStatus> subscription;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

//handle location permission'
  Future<void> handleLocationPermission() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      print(
          "Location service is OFF. You can prompt the user to enable it if needed.");
    } else {
      print("Location service is ON");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    print("Initial permission: $permission");

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("Permission after request: $permission");

      if (permission == LocationPermission.denied) {
        print("Permission denied. App will continue without location access.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          "Permission permanently denied. App will continue without location access.");
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      try {
        Position position = await Geolocator.getCurrentPosition();
        print('Location: ${position.latitude}, ${position.longitude}');
      } catch (e) {
        print("Error getting location: $e");
      }
    } else {
      print(
          "Location permission denied or not granted. App will continue without location access.");
    }
  }

  //  Monitor internet connectivity
  void _startMonitoring() {
    subscription = InternetConnectionChecker.createInstance()
        .onStatusChange
        .listen((InternetConnectionStatus status) async {
      if (status == InternetConnectionStatus.connected) {
        print('Connected to the Internet');
        await Future.delayed(Duration(seconds: 5));
        await _proceedAfterConnection();
      } else {
        print('No Internet Connection');
        _showNoInternetDialog();
      }
    });
  }

  //  Proceeds only after internet is confirmed
  Future<void> _proceedAfterConnection() async {
    try {
      await handleLocationPermission();
      await _checkLoginState();
    } on SocketException catch (_) {
      _showSocketErrorDialog();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  // Dialog for socket error (e.g., API not reachable)
  void _showSocketErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Connection Error"),
          content: Text("Unable to connect to the server. Please try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkLoginState(); // Retry login check
              },
              child: Text("Retry"),
            ),
          ],
        );
      },
    );
  }

  void _showNoInternetDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection.'),
          actions: <Widget>[
            TextButton(
              child: Text('Retry'),
              onPressed: () async {
                Navigator.of(context).pop();
                final checker = InternetConnectionChecker.createInstance();
                bool connected = await checker.hasConnection;
                if (connected) {
                  await _proceedAfterConnection();
                } else {
                  _showNoInternetDialog();
                }
              },
            ),
          ],
        );
      },
    );
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
        if (isTokenExpired) {
          try {
            print(isTokenExpired);
            await authProvider.refreshAccessToken(context);
          } on SocketException catch (_) {
            _showSocketErrorDialog();
            return;
          }
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
    } on SocketException catch (_) {
      _showSocketErrorDialog();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    subscription.cancel();
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
              : Image.asset('assets/logo/logo.jpeg', height: 100),
        ),
      ),
    );
  }
}
