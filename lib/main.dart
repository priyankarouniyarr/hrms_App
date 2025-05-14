import 'package:flutter/material.dart';
import 'package:hrms_app/dependencyInjectio.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/splash_scren.dart';
import 'package:hrms_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hrms_app/screen/homescreen/notifications.dart';
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
import 'package:hrms_app/providers/connection_checker/check_connection_provider.dart';
import 'package:hrms_app/providers/profile_providers/employee_contract_provider.dart';
import 'package:hrms_app/providers/hosptial_code_provider/hosptial_code_provider.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_history_provider.dart';
import 'package:hrms_app/providers/works_Summary_provider/summary_details/assign_by_me_ticket_provider.dart';
import 'package:hrms_app/providers/leaves_provider/leaves_history%20_contract%20and%20fiscalyear_period.dart';
import 'package:hrms_app/providers/works_Summary_provider/summary_details/my_ticket_get_summary_provider.dart';

// ✅ Create a global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// ✅ Background handler
Future<void> _backgroundHandler(RemoteMessage message) async {
  print('🔄 Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    firebaseMessaging();
  }

  void firebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get the token
    String? token = await messaging.getToken();
    print('FCM Token: $token');

    // Foreground notifications using navigatorKey safely
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'No Title';
      final body = message.notification?.body ?? 'No Body';

      if (navigatorKey.currentState?.context != null) {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(
              body,
              maxLines: 2,
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Notifications(
                        title: title,
                        body: body,
                      ),
                    ),
                  );
                },
                child: Text("View"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
            ],
          ),
        );
      } else {
        print(' No context available to show dialog');
      }
    });

    // When app is in background and opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'No Title';
      final body = message.notification?.body ?? 'No Body';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Notifications(
            title: title,
            body: body,
          ),
        ),
      );
    });

    // When app is terminated and opened from notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        final title = message.notification?.title ?? 'No Title';
        final body = message.notification?.body ?? 'No Body';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Notifications(
              title: title,
              body: body,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CheckNetworkProvider()),
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
          ChangeNotifierProvider(create: (context) => SalaryProvider()),
          ChangeNotifierProvider(
              create: (context) => MyTicketGetSummaryProvider()),
          ChangeNotifierProvider(
              create: (context) => AssignByMeTicketProvider()),
          ChangeNotifierProvider(create: (context) => NewTicketProvider()),
          ChangeNotifierProvider(create: (context) => TicketProvider()),
          ChangeNotifierProvider(create: (context) => LeaveRequestProvider()),
          ChangeNotifierProvider(create: (context) => TicketWorkFlowProvider()),
          ChangeNotifierProvider(create: (context) => ShareliveLocation()),
          ChangeNotifierProvider(
              create: (context) => FcmnotificationProvider()),
        ],
        child: Builder(builder: (context) {
          Dependencyinjection.init(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        }));
  }
}
