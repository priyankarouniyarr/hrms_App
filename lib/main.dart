import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/screen/onboardscreen.dart';
import 'package:hrms_app/providers/auth_provider.dart';
import 'package:hrms_app/providers/notices_provider.dart';
import 'package:hrms_app/providers/holidays_provider.dart';
import 'package:hrms_app/providers/check_in_provider.dart';
import 'package:hrms_app/providers/branch_id_provider.dart';
import 'package:hrms_app/providers/fiscal_year_provider.dart';
import 'package:hrms_app/providers/hosptial_code_provider.dart';

void main() {
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
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardScreen(),
    );
  }
}
