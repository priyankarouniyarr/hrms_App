import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/screen/leaves/customtextfieldform.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialize the provider when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<AttendanceDetailsProvider>(context, listen: false);
      provider
          .initialize(); // This loads the secure data and fetches attendance data
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the provider without Consumer
    final provider = Provider.of<AttendanceDetailsProvider>(context);
    print(provider.isLoading);

    // Show loading while data is being fetched
    if (provider.isLoading) {
      return Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: CustomAppBarProfile(title: "Attendance Details"),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Display the attendance data after it's loaded
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "Attendance Details"),
      body: Padding(
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
            const SizedBox(
              height: 10,
            ),
            // Dropdown for shift type options
            CustomDropdown(
              value: _selectedShiftValue,
              items: provider.shiftTypes, // Populate dropdown with shift types
              hintText: "Select Shift",
              onChanged: (value) {
                setState(() {
                  _selectedShiftValue = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
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
                                      color: accentColor,
                                    ),
                                  ),
                                  backgroundColor: cardBackgroundColor,
                                ),
                              );
                              return;
                            }
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _startDate!.add(Duration(days: 1)),
                              firstDate: _startDate!.add(Duration(days: 1)),
                              lastDate:
                                  DateTime.now().subtract(Duration(days: 1)),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _endDate = pickedDate;
                                _enddatecontroller.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
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
                  provider.fetchAttendanceData(
                    fromDate: _startDate!,
                    toDate: _endDate!,
                    shiftType: _selectedShiftValue!,
                  );
                }
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 100,
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
            // Display Attendance Details if they are loaded
            provider.attendanceDetails == null
                ? Text("No attendance details found",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.5),
                    ))
                : Text(
                    "Total Attendance: ${provider.attendanceDetails?.attendanceSummary.length}",
                    style: TextStyle(fontSize: 20),
                  ),
          ],
        ),
      ),
    );
  }
}
