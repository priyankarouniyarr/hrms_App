import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/splash_scren.dart';
import 'package:hrms_app/notifications.dart';
import 'package:hrms_app/firebase_options.dart';
import 'package:hrms_app/push_notification.dart';
import 'package:hrms_app/utlis/connectivity.dart';
import 'package:hrms_app/localnotifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hrms_app/providers/payroll/payroll_provider.dart';
import 'package:hrms_app/providers/notices_provider/notices_provider.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
import 'package:hrms_app/providers/notifications/notification_provider.dart';
import 'package:hrms_app/providers/login_screen_provider/auth_provider.dart';
import 'package:hrms_app/providers/check-in_provider/check_in_provider.dart';
import 'package:hrms_app/providers/holidays_provider/holidays_provider.dart';
import 'package:hrms_app/providers/create_tickets/new_tickets_provider.dart';
import 'package:hrms_app/providers/create_tickets/ne_tickets_providers.dart';
import 'package:hrms_app/providers/leaves_provider/leavehistory_provider.dart';
import 'package:hrms_app/providers/branch_id_providers/branch_id_provider.dart';
import 'package:hrms_app/providers/works_Summary_provider/ticket_workflow.dart';
import 'package:hrms_app/providers/leaves_provider/leave_request_provider.dart';
import 'package:hrms_app/providers/check-in_provider/sharelive%20_location.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_provider.dart';
import 'package:hrms_app/providers/fiscal_year_provider/fiscal_year_provider.dart';
import 'package:hrms_app/providers/payroll/payroll_monthly_salarayy_provider.dart';
import 'package:hrms_app/providers/profile_providers/employee_contract_provider.dart';
import 'package:hrms_app/providers/hosptial_code_provider/hosptial_code_provider.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_history_provider.dart';
import 'package:hrms_app/providers/works_Summary_provider/summary_details/assign_by_me_ticket_provider.dart';
import 'package:hrms_app/providers/leaves_provider/leaves_history%20_contract%20and%20fiscalyear_period.dart';
import 'package:hrms_app/providers/works_Summary_provider/summary_details/my_ticket_get_summary_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService().initialize();
  await PushNotificationManager.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ConnectivityHandler connectivityHandler;

  @override
  void initState() {
    super.initState();
    connectivityHandler = ConnectivityHandler(navigatorKey: navigatorKey);
    connectivityHandler.init(setState, () {});
  }

  @override
  void dispose() {
    connectivityHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HospitalCodeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BranchProvider()),
        ChangeNotifierProvider(create: (_) => FiscalYearProvider()),
        ChangeNotifierProvider(create: (_) => CheckInProvider()),
        ChangeNotifierProvider(create: (_) => HolidayProvider()),
        ChangeNotifierProvider(create: (_) => NoticesProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceDetailsProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeContractProvider()),
        ChangeNotifierProvider(create: (_) => LoanAndAdvanceProvider()),
        ChangeNotifierProvider(create: (_) => LeaveProvider()),
        ChangeNotifierProvider(
            create: (_) => LeaveContractandFiscalYearProvider()),
        ChangeNotifierProvider(create: (_) => SalaryProvider()),
        ChangeNotifierProvider(create: (_) => MyTicketGetSummaryProvider()),
        ChangeNotifierProvider(create: (_) => AssignByMeTicketProvider()),
        ChangeNotifierProvider(create: (_) => NewTicketProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => LeaveRequestProvider()),
        ChangeNotifierProvider(create: (_) => TicketWorkFlowProvider()),
        ChangeNotifierProvider(create: (_) => ShareliveLocation()),
        ChangeNotifierProvider(create: (_) => FcmnotificationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: Builder(builder: (BuildContext context) {
          if (connectivityHandler.isCheckingConnected) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SplashScreen();
          }
        }),
      ),
    );
  }
}
