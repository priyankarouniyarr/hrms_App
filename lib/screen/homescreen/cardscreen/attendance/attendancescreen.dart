import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_provider.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/attendance/attendancehistory.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Provider.of<AttendanceProvider>(context, listen: false)
          .fetchAttendanceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    if (attendanceProvider.isLoading) {
      return const Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: CustomAppBarProfile(title: "View Attendance"),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show error message if there was an issue fetching the data
    if (attendanceProvider.errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: const CustomAppBarProfile(title: "View Attendance"),
        body: Center(child: Text(attendanceProvider.errorMessage)),
      );
    }

    final primaryShiftAttendance = attendanceProvider.primaryShiftAttendance;
    final extendedShiftAttendance = attendanceProvider.extendedShiftAttendance;

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "View Attendance"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Primary Shift', style: _titleStyle),
              SizedBox(height: 10),
              _buildTwoColumnLayout(
                  primaryShiftAttendance.map((attendanceData) {
                return _buildCategoryTile(
                    attendanceData.category, attendanceData.qty);
              }).toList()),
              SizedBox(height: 20),
              Text('Extended Shift', style: _titleStyle),
              SizedBox(height: 10),
              _buildTwoColumnLayout(
                  extendedShiftAttendance.map((attendanceData) {
                return _buildCategoryTile(
                    attendanceData.category, attendanceData.qty);
              }).toList()),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AttendanceDetailsScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    color: primarySwatch[900],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text('Attendance History', style: _buttonStyle),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final _titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final _buttonStyle =
      TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);

  Widget _buildTwoColumnLayout(List<Widget?> tiles) {
    List<Widget?> filteredTiles = tiles.where((tile) => tile != null).toList();

    return Column(
      children: [
        for (int i = 0; i < filteredTiles.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: filteredTiles[i]!),
                SizedBox(width: 10),
                if (i + 1 < filteredTiles.length)
                  Expanded(child: filteredTiles[i + 1]!)
                else
                  Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryTile(String category, int qty) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primarySwatch[900]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          SizedBox(height: 5),
          Text('$qty',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primarySwatch[900])),
        ],
      ),
    );
  }
}
