import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/onboardscreen.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/screen/shifting/Shifting.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/works.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/notices/notices.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/check-in/check-in.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/new%20ticket/ticket.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/holiday.dart/holiday.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/attendance/attendancescreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> menuItems = [
    {'label': 'Attendance', 'icon': Icons.pie_chart, 'color': Colors.green},
    {'label': 'Works', 'icon': Icons.assignment, 'color': Colors.orange},
    {'label': 'New Ticket', 'icon': Icons.add_circle, 'color': Colors.purple},
    {'label': 'Holidays', 'icon': Icons.house, 'color': Colors.red},
    {
      'label': 'Notices',
      'icon': Icons.message_outlined,
      'color': Colors.yellow[700]
    },
    {'label': 'Check In', 'icon': Icons.location_on, 'color': Colors.teal},
  ];

  Future<void> _checkUserData() async {
    final SecureStorageService secureStorageService = SecureStorageService();

    final branchId =
        await secureStorageService.readData('selected_workingbranchId');

    final username = await secureStorageService.readData('username');

    final fiscalYear =
        await secureStorageService.readData('selected_fiscal_year');

    if (username == null || branchId == null || fiscalYear == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardScreen()),
        );
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _checkUserData();
    super.initState();
  }

//
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmployeeProvider>(context);
    String username = provider.firstname ?? '';

    return Scaffold(
      backgroundColor: primarySwatch[900],
      appBar: AppBar(
        backgroundColor: primarySwatch[900],
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: cardBackgroundColor,
              radius: 30,
              child: IconButton(
                icon: Icon(
                  Icons.notifications_active_outlined,
                  color: secondaryColor,
                  size: 28,
                ),
                onPressed: () {},
                splashRadius: 24,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hey, $username 👋",
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "What do you want to do today?",
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              // Shifting screen
              // ignore: unnecessary_null_comparison
              provider.currentShift == null
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: ShiftScreen(),
                    ),
              SizedBox(height: 15),
              Container(
                height: MediaQuery.of(context).size.height /
                    1.5, // Adjust based on need
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                padding: EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: menuItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return _buildMenuItem(context, item);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          color: Colors.white,
          child: InkWell(
            onTap: () {
              if (item['label'] == 'Attendance') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AttendanceScreen()),
                );
              } else if (item['label'] == 'Works') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkScreen()),
                );
              } else if (item['label'] == 'Holidays') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HolidayScreen()),
                );
              } else if (item['label'] == 'Check In') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckInScreen()),
                );
              } else if (item['label'] == 'New Ticket') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateTicketScreen()),
                );
              } else if (item['label'] == 'Notices') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticesScreen()),
                );
              }
            },
            borderRadius: BorderRadius.circular(16),
            splashColor: item['color'].withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                item['icon'],
                color: item['color'],
                size: 35,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          item['label'],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: primaryTextColor,
          ),
        ),
      ],
    );
  }
}
