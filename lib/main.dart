import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms_app/splash_scrren.dart';
import 'package:hrms_app/providers/payroll/payroll_provider.dart';
import 'package:hrms_app/providers/notices_provider/notices_provider.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
import 'package:hrms_app/providers/login_screen_provider/auth_provider.dart';
import 'package:hrms_app/providers/check-in_provider/check_in_provider.dart';
import 'package:hrms_app/providers/holidays_provider/holidays_provider.dart';
import 'package:hrms_app/providers/create_tickets/new_tickets_provider.dart';
import 'package:hrms_app/providers/create_tickets/ne_tickets_providers.dart';
import 'package:hrms_app/providers/leaves_provider/leavehistory_provider.dart';
import 'package:hrms_app/providers/branch_id_providers/branch_id_provider.dart';
import 'package:hrms_app/providers/works_Summary_provider/ticket_workflow.dart';
import 'package:hrms_app/providers/leaves_provider/leave_request_provider.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_provider.dart';
import 'package:hrms_app/providers/fiscal_year_provider/fiscal_year_provider.dart';
import 'package:hrms_app/providers/payroll/payroll_monthly_salarayy_provider.dart';
import 'package:hrms_app/providers/profile_providers/employee_contract_provider.dart';
import 'package:hrms_app/providers/hosptial_code_provider/hosptial_code_provider.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_history_provider.dart';
import 'package:hrms_app/providers/works_Summary_provider/summary_details/assign_by_me_ticket_provider.dart';
import 'package:hrms_app/providers/leaves_provider/leaves_history%20_contract%20and%20fiscalyear_period.dart';
import 'package:hrms_app/providers/works_Summary_provider/summary_details/my_ticket_get_summary_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await handleLocationPermission();

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
        ChangeNotifierProvider(create: (context) => LeaveProvider()),
        ChangeNotifierProvider(
            create: (context) => LeaveContractandFiscalYearProvider()),
        ChangeNotifierProvider(create: (context) => SalaryProvider()),
        ChangeNotifierProvider(
            create: (context) => MyTicketGetSummaryProvider()),
        ChangeNotifierProvider(create: (context) => AssignByMeTicketProvider()),
        ChangeNotifierProvider(create: (context) => NewTicketProvider()),
        ChangeNotifierProvider(create: (context) => TicketProvider()),
        ChangeNotifierProvider(create: (context) => LeaveRequestProvider()),
        ChangeNotifierProvider(create: (context) => TicketWorkFlowProvider()),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> handleLocationPermission() async {
  // Check if location services are enabled
  bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isLocationServiceEnabled) {
    print(
        "Location service is OFF. You can prompt the user to enable it if needed.");
  } else {
    print("Location service is ON");
  }

  // Check location permission
  LocationPermission permission = await Geolocator.checkPermission();
  print("Initial permission: $permission");

  if (permission == LocationPermission.denied) {
    // Request permission if not granted
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

  // If permission is granted, get the current location
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

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool isLoggedIn = false;
//   bool isLoading = true;
//   loadState(context) async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     await authProvider.loadToken();
//     await authProvider.loadUsername();
//     await authProvider.loadRefreshToken();

//     if (authProvider.token == null) {
//       // print("hello");

//       isLoggedIn = false;
//     } else {
//       bool isTokenExpired = await authProvider.isTokenExpired();
//       if (isTokenExpired) {
//         await authProvider.refreshAccessToken();
//         isLoggedIn = true;
//       } else {
//         isLoggedIn = true;
//       }
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       loadState(context);
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Builder(builder: (context) {
//           if (isLoading) {
//             return Scaffold(
//               backgroundColor: primarySwatch,
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }
//           print(isLoggedIn);
//           if (!isLoggedIn) {
//             return OnboardScreen();
//           }

//           return AppMainScreen();
//         }));
//   }
// }
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
