import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/onboardscreen.dart';
import 'package:hrms_app/screen/homescreen/homepage.dart';
import 'package:hrms_app/screen/leaves/leaves_screen.dart';
import 'package:hrms_app/screen/payroll/payroll_screen.dart';
import 'package:hrms_app/screen/profile/profile_screen.dart';
import 'package:hrms_app/storage/securestorage.dart' show SecureStorageService;

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _selectedIndex = 0; // Track the selected index
  final List<Widget> pages = [
    HomeScreen(),
    PayrollScreen(),
    LeavesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
        selectedItemColor: primarySwatch[900],
        unselectedItemColor: primarySwatch.withOpacity(0.6),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home_filled : Icons.home_outlined,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1
                  ? Icons.account_balance_wallet
                  : Icons.account_balance_outlined,
            ),
            label: "Payroll",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? Icons.email : Icons.email_outlined,
            ),
            label: "Leaves",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3 ? Icons.person : Icons.person_outlined,
            ),
            label: "Profile",
          ),
        ],
      ),
      body: pages[_selectedIndex], // Display selected page
    );
  }
}
