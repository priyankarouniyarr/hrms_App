import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/screen/leaves/customtextfieldform.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_provider.dart';
import 'package:hrms_app/models/attendance%20_models/attendance_details_models.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_history_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class AttendanceDetailsScreen extends StatefulWidget {
  @override
  _AttendanceDetailsScreenState createState() =>
      _AttendanceDetailsScreenState();
}

class _AttendanceDetailsScreenState extends State<AttendanceDetailsScreen> {
  String? _selectedShiftValue;
  TextEditingController _startdatecontroller = TextEditingController();
  TextEditingController _enddatecontroller = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showAttendanceDetails =
      false; // Flag to control attendance details display

  @override
  void initState() {
    super.initState();
    final filter = Filter(
      fromDate:
          DateTime.now().subtract(Duration(days: 30)), // Example: last 30 days
      toDate: DateTime.now().subtract(Duration(days: 1)),
      shiftType: '',
    );

    Future.microtask(() async {
      await Provider.of<AttendanceDetailsProvider>(context, listen: false)
          .fetchAttendanceSummary(filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceDetailsProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final screenHeight =
        MediaQuery.of(context).size.height; // Get screen height

    if (provider.isLoading) {
      return Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: CustomAppBarProfile(title: "Attendance Details"),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "Attendance Details"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Shift",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                CustomDropdown(
                  value: _selectedShiftValue,
                  items: provider
                      .shiftTypes, // Now includes Primary, Extended, and dynamic shift types
                  hintText: "Select Shift",
                  onChanged: (value) {
                    setState(() {
                      _selectedShiftValue = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      // Start Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Start Date",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            CustomTextFormField(
                              controller: _startdatecontroller,
                              hintText: "Start date",
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    _startDate = pickedDate;
                                    _startdatecontroller.text =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // End Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "End Date",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            CustomTextFormField(
                              controller: _enddatecontroller,
                              hintText: "End date",
                              readOnly: true,
                              onTap: () async {
                                if (_startDate == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please select start date first",
                                        style: TextStyle(
                                            color: accentColor, fontSize: 18),
                                      ),
                                      backgroundColor: cardBackgroundColor,
                                    ),
                                  );
                                  return;
                                }
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      _startDate!.add(Duration(days: 1)),
                                  firstDate: _startDate!.add(Duration(days: 1)),
                                  lastDate: DateTime.now()
                                      .subtract(Duration(days: 1)),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    _endDate = pickedDate;
                                    _enddatecontroller.text =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    if (_selectedShiftValue != null &&
                        _startDate != null &&
                        _endDate != null) {
                      provider.fetchAttendanceSummary(
                        Filter(
                          fromDate: _startDate!,
                          toDate: _endDate!,
                          shiftType:
                              _selectedShiftValue!, // Pass selected shift type
                        ),
                      );

                      setState(() {});
                      _showAttendanceDetails = true;
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: screenWidth * 0.4, // 40% of screen width
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: primarySwatch[900],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'View',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _showAttendanceDetails
                    ? (provider.attendanceReport == null ||
                            provider.summaryAttendance == null ||
                            provider.summaryAttendance.isEmpty)
                        ? Text(
                            "No attendance details found",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          )
                        : Wrap(
                            spacing: 10, // Space between boxes horizontally
                            runSpacing: 10, // Space between boxes vertically
                            children: provider.summaryAttendance
                                .map((item) =>
                                    _buildAttendanceCard(item, screenWidth))
                                .toList(),
                          )
                    : Container(),
                SizedBox(height: 20),
                _showAttendanceDetails
                    ? (provider.attendanceReport == null ||
                            provider.detailsAttendance == null ||
                            provider.detailsAttendance.isEmpty)
                        ? Text(
                            "No attendance details found",
                            style: TextStyle(
                              fontSize: 18,
                              color: accentColor,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0;
                                  i < provider.detailsAttendance.length;
                                  i++)
                                Card(
                                  color: Colors.white,
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                        color: primarySwatch, width: 1),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              ' ${DateFormat('dd-MM-yyyy').format(provider.detailsAttendance[i].attendanceDate)}',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 50),
                                            Flexible(
                                              child: Text(
                                                provider.detailsAttendance[i]
                                                        .statusFullName ??
                                                    '-',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: provider
                                                                  .detailsAttendance[
                                                                      i]
                                                                  .statusColorCode !=
                                                              null &&
                                                          provider
                                                              .detailsAttendance[
                                                                  i]
                                                              .statusColorCode
                                                              .startsWith(
                                                                  "#") &&
                                                          provider
                                                                  .detailsAttendance[
                                                                      i]
                                                                  .statusColorCode
                                                                  .length ==
                                                              7
                                                      ? Color(int.parse(provider
                                                          .detailsAttendance[i]
                                                          .statusColorCode
                                                          .replaceFirst(
                                                              "#", "0xFF")))
                                                      : Colors.black,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        _buildDetailRow(
                                            "Shift Name",
                                            provider.detailsAttendance[i]
                                                .shiftTitle),
                                        _buildDetailRow(
                                            "Shift Time",
                                            provider.detailsAttendance[i]
                                                .shiftTime),
                                        _buildDetailRow(
                                            "In Time",
                                            provider.detailsAttendance[i]
                                                        .checkInTime !=
                                                    null
                                                ? DateFormat('hh:mm a').format(
                                                    provider
                                                        .detailsAttendance[i]
                                                        .checkInTime!)
                                                : '-'),
                                        _buildDetailRow(
                                            "Out Time",
                                            provider.detailsAttendance[i]
                                                        .checkOutTime !=
                                                    null
                                                ? DateFormat('hh:mm a').format(
                                                    provider
                                                        .detailsAttendance[i]
                                                        .checkOutTime!)
                                                : '-'),
                                        _buildDetailRow(
                                            "Break",
                                            (provider.detailsAttendance[i]
                                                            .breakInTime !=
                                                        null
                                                    ? DateFormat('hh:mm a')
                                                        .format(provider
                                                            .detailsAttendance[
                                                                i]
                                                            .breakInTime!)
                                                    : '') +
                                                " - " +
                                                (provider.detailsAttendance[i]
                                                            .breakOutTime !=
                                                        null
                                                    ? DateFormat('hh:mm a')
                                                        .format(provider
                                                            .detailsAttendance[
                                                                i]
                                                            .breakOutTime!)
                                                    : '-')),
                                        _buildDetailRow(
                                            "Remarks",
                                            provider.detailsAttendance[i]
                                                    .remarks
                                                    ?.toString() ??
                                                '-'),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    ),
  );
}

// Function to build a simple attendance card
Widget _buildAttendanceCard(attendanceItem, double screenWidth) {
  return Container(
    width: screenWidth * 0.45, // 45% of screen width
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: primarySwatch, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          attendanceItem.category,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          '${attendanceItem.qty.toInt()}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primarySwatch,
          ),
        ),
      ],
    ),
  );
}
