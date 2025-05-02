import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/screen/onboardscreen.dart';
import 'package:hrms_app/storage/token_storage.dart';
import 'package:hrms_app/screen/app_main_screen.dart';
import 'package:hrms_app/providers/login_screen_provider/auth_provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:hrms_app/providers/branch_id_providers/branch_id_provider.dart';
import 'package:hrms_app/providers/fiscal_year_provider/fiscal_year_provider.dart';

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

    _checkLoginState();
  }

//handle location permission'

  //  Monitor internet connectivity
  // void _startMonitoring() {
  //   subscription = InternetConnectionChecker.createInstance()
  //       .onStatusChange
  //       .listen((InternetConnectionStatus status) async {
  //     if (status == InternetConnectionStatus.connected) {
  //       print('Connected to the Internet');
  //       await Future.delayed(Duration(seconds: 5));
  //       await _proceedAfterConnection();
  //     } else {
  //       print('No Internet Connection');
  //       _showNoInternetDialog();
  //     }
  //   });
  // }

  // //  Proceeds only after internet is confirmed
  // Future<void> _proceedAfterConnection() async {
  //   try {
  //     await _checkLoginState();
  //   } on SocketException catch (_) {
  //     _showSocketErrorDialog();
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = e.toString();
  //     });
  //   }
  // }

  //Dialog for socket error (e.g., API not reachable)
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
                _checkLoginState();
              },
              child: Text("Retry"),
            ),
          ],
        );
      },
    );
  }

  // void _showNoInternetDialog() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('No Internet Connection'),
  //         content: Text('Please check your internet connection.'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Retry'),
  //             onPressed: () async {
  //               Navigator.of(context).pop();
  //               final checker = InternetConnectionChecker.createInstance();
  //               bool connected = await checker.hasConnection;
  //               if (connected) {
  //                 await _proceedAfterConnection();
  //               } else {
  //                 _showNoInternetDialog();
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
          try {
            print(isTokenExpired);
            await authProvider.refreshAccessToken(context);
            isLoggedIn = true;
          } on SocketException catch (_) {
            _showSocketErrorDialog();
            return;
          }
        } else {
          isLoggedIn = true;
        }
      }

      if (isLoggedIn) {
        //only after login sucess :checking branch id and fiscal year id

        try {
          final branchid = Provider.of<BranchProvider>(context, listen: false);

          final fiscalyear =
              Provider.of<FiscalYearProvider>(context, listen: false);

          await branchid.fetchUserBranches();
          await fiscalyear.fetchFiscalYears(
            int.parse(branchid.branches.first.branchId.toString()),
          );
        } on SocketException catch (_) {
          _showSocketErrorDialog();
          return;
        } catch (e) {
          await _showErrorDialogAndReset(); // Reset app on error

          return;
        }
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isLoggedIn ? const AppMainScreen() : OnboardScreen(),
        ),
      );
    } on SocketException catch (_) {
      _showSocketErrorDialog();
    } catch (e) {
      await _showErrorDialogAndReset(); // Reset app on error
    }
  }

  Future<void> _showErrorDialogAndReset() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Something went wrong"),
        content: const Text("Please try again."),
        actions: [
          TextButton(
            onPressed: () async {
              final tokenStorage = TokenStorage();
              await tokenStorage.removeToken();
              await tokenStorage.removeUsername();
              await tokenStorage.removeRefreshToken();
              await tokenStorage.removeExpirationTime();
              await tokenStorage.removeHospitalCode();
              await tokenStorage.removeBranchId();
              await tokenStorage.removeBranchIdAndFiscalYearId();

              Navigator.of(context).pop(); // Close the dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OnboardScreen()), // Navigate to Onboarding
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // void dispose() {
  //   subscription?.cancel();
  //   super.dispose();
  // }

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
