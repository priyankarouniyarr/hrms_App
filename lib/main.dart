import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/splash_scren.dart';
import 'package:hrms_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:hrms_app/providers/connectivity_checker/connectivity_provider.dart';
import 'package:hrms_app/providers/profile_providers/employee_contract_provider.dart';
import 'package:hrms_app/providers/hosptial_code_provider/hosptial_code_provider.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_history_provider.dart';
import 'package:hrms_app/providers/works_Summary_provider/summary_details/assign_by_me_ticket_provider.dart';
import 'package:hrms_app/providers/leaves_provider/leaves_history%20_contract%20and%20fiscalyear_period.dart';
import 'package:hrms_app/providers/works_Summary_provider/summary_details/my_ticket_get_summary_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
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
        ChangeNotifierProvider(create: (context) => ShareliveLocation()),
        ChangeNotifierProvider(
          create: (context) => FcmnotificationProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
