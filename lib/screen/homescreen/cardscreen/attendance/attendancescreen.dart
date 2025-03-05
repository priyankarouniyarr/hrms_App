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
  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final attendance = attendanceProvider.attendance;

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "View Attendance"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: attendance == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Primary Shift', style: _titleStyle),
                    SizedBox(height: 10),
                    _buildTwoColumnLayout([
                      _buildCategoryTile(
                          'Working Days', attendance.workingDaysPrimary),
                      _buildCategoryTile('Present', attendance.presentPrimary),
                      _buildCategoryTile('Week End', attendance.weekendPrimary),
                      _buildCategoryTile('Leave', attendance.leavePrimary),
                      _buildCategoryTile('Absent', attendance.absentPrimary),
                    ]),
                    SizedBox(height: 20),
                    Text('Extended Shift', style: _titleStyle),
                    SizedBox(height: 10),
                    _buildTwoColumnLayout([
                      _buildCategoryTile(
                          'Working Days', attendance.workingDaysExtended),
                      _buildCategoryTile('Present', attendance.presentExtended),
                      _buildCategoryTile(
                          'Week End', attendance.weekendExtended),
                      _buildCategoryTile('Leave', attendance.leaveExtended),
                      _buildCategoryTile('Absent', attendance.absentExtended),
                    ]),
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
                          child:
                              Text('Attendance History', style: _buttonStyle),
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
    // Remove null tiles
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
                SizedBox(width: 10), // Space between the tiles
                if (i + 1 < filteredTiles.length)
                  Expanded(child: filteredTiles[i + 1]!)
                else
                  Expanded(
                      child: SizedBox()), // In case of an odd number of tiles
              ],
            ),
          ),
      ],
    );
  }

  Widget? _buildCategoryTile(String category, int? value) {
    if (value == null || value == 0) return null;

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
          Text('$value',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primarySwatch[900])),
        ],
      ),
    );
  }
}
