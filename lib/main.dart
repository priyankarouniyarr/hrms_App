import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms_app/screen/onboardscreen.dart';
import 'package:hrms_app/screen/app_main_screen.dart';
import 'package:hrms_app/providers/payroll_provider.dart';
import 'package:hrms_app/providers/notices_provider.dart';
import 'package:hrms_app/providers/holidays_provider.dart';
import 'package:hrms_app/providers/check_in_provider.dart';
import 'package:hrms_app/providers/branch_id_provider.dart';
import 'package:hrms_app/providers/fiscal_year_provider.dart';
import 'package:hrms_app/providers/hosptial_code_provider.dart';
import 'package:hrms_app/models/leaves/leave_history_models.dart';
import 'package:hrms_app/providers/employee_contract_provider.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
import 'package:hrms_app/providers/auth_provider.dart'; // Import AuthProvider
import 'package:hrms_app/providers/leaves_provider/leavehistory_provider.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_provider.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_history_provider.dart';
import 'package:hrms_app/providers/leaves_provider/leaves_history%20_contract%20and%20fiscalyear_period.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if location services are enabled
  bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!isLocationServiceEnabled) {
    // Request to enable location services
    bool serviceEnabled = await Geolocator.openLocationSettings();
    if (!serviceEnabled) {
      // Handle the case where the user did not enable location services
      return;
    }
  }

  // Check location permissions
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle the case where the user denied permissions
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Handle the case where the user permanently denied permissions
    return;
  }

  // Wait for AuthProvider to load token and refresh if necessary
  // final authProvider = AuthProvider();
  // await authProvider.loadToken();
  // await authProvider.loadRefreshToken();

  // // Check if the token is expired
  // bool isLoggedIn;

  // if (authProvider.token == null) {
  //   print("hello");
  //   isLoggedIn = false;
  // } else {
  //   // Token is present, check if it needs refreshing
  //   bool isTokenExpired = await authProvider.isTokenExpired();
  //   if (isTokenExpired) {
  //     await authProvider.refreshAccessToken();
  //     isLoggedIn = true;
  //   } else {
  //     isLoggedIn = true;
  //   }
  // }

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => HospitalCodeProvider()),
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => BranchProvider()),
          ChangeNotifierProvider(create: (context) => FiscalYearProvider()),
          ChangeNotifierProvider(create: (context) => CheckInProvider()),
          ChangeNotifierProvider(create: (context) => HolidayProvider()),
          ChangeNotifierProvider(create: (context) => NoticesProvider()),
          ChangeNotifierProvider(create: (context) => AttendanceProvider()),
          ChangeNotifierProvider(
              create: (context) => AttendanceDetailsProvider()),
          ChangeNotifierProvider(create: (context) => EmployeeProvider()),
          ChangeNotifierProvider(
              create: (context) => EmployeeContractProvider()),
          ChangeNotifierProvider(create: (context) => LoanAndAdvanceProvider()),
          ChangeNotifierProvider(create: (context) => LeaveProvider()),
          ChangeNotifierProvider(
              create: (context) => LeaveContractandFiscalYearProvider()),
        ],
        child: //MyApp(isLoggedIn: isLoggedIn),
            MyApp() // Pass the login status to MyApp
        ),
  );
}

class MyApp extends StatelessWidget {
  // final bool isLoggedIn;

  // MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: isLoggedIn ? AppMainScreen() : OnboardScreen(),
      home: OnboardScreen(),
    );
  }
}
