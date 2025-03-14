import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/screen/onboardscreen.dart';
import 'package:hrms_app/screen/app_main_screen.dart';
import 'package:hrms_app/providers/auth_provider.dart';
import 'package:hrms_app/providers/payroll_provider.dart';
import 'package:hrms_app/providers/notices_provider.dart';
import 'package:hrms_app/providers/holidays_provider.dart';
import 'package:hrms_app/providers/check_in_provider.dart';
import 'package:hrms_app/providers/branch_id_provider.dart';
import 'package:hrms_app/providers/fiscal_year_provider.dart';
import 'package:hrms_app/providers/hosptial_code_provider.dart';
import 'package:hrms_app/providers/employee_contract_provider.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_provider.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/attendance/attendancehistory.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_history_provider.dart';

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
        ChangeNotifierProvider(create: (context) => AttendanceProvider()),
        ChangeNotifierProvider(
            create: (context) => AttendanceDetailsProvider()),
        ChangeNotifierProvider(create: (context) => EmployeeProvider()),
        ChangeNotifierProvider(create: (context) => EmployeeContractProvider()),
        ChangeNotifierProvider(create: (context) => LoanAndAdvanceProvider()),
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
      //AppMainScreen(),
    );
  }
}
