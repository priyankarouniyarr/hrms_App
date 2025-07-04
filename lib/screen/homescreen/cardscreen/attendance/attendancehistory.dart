import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/widget/dropdown_custom.dart';
import 'package:hrms_app/widget/customtextfieldform.dart';
import 'package:hrms_app/models/attendance%20_models/attendance_details_models.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_history_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class AttendanceDetailsScreen extends StatefulWidget {
  const AttendanceDetailsScreen({super.key});

  @override
  _AttendanceDetailsScreenState createState() =>
      _AttendanceDetailsScreenState();
}

class _AttendanceDetailsScreenState extends State<AttendanceDetailsScreen> {
  String? _selectedShiftValue;
  String? _selectedStatus;
  final TextEditingController _startdatecontroller = TextEditingController();
  final TextEditingController _enddatecontroller = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showAttendanceDetails = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceDetailsProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width

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
                                  initialDate: _startDate!,
                                  firstDate: _startDate!,
                                  lastDate: DateTime.now(),
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
                // Text(
                //   "Status",
                //   style: TextStyle(
                //     fontSize: 18,
                //   ),
                // ),
                // const SizedBox(height: 10),
                // CustomDropdown(
                //   value: _selectedStatus,
                //   items: provider.status,
                //   hintText: "Status",
                //   onChanged: (value) {
                //     setState(() {
                //       _selectedStatus = value;
                //     });
                //   },
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                GestureDetector(
                  onTap: () {
                    if (_selectedShiftValue != null &&
                        _startDate != null &&
                        _endDate != null) {
                      provider.fetchAttendanceSummary(
                        Filter(
                          fromDate: _startDate!,
                          toDate: _endDate!,
                          shiftType: _selectedShiftValue!,
                          // Pass selected shift type
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
                            provider.errorMessage,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red.withOpacity(0.5),
                            ),
                          )
                        : Wrap(
                            spacing: 10,
                            runSpacing: 10,
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
                            provider.errorMessage,
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
                                                    .statusFullName,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: provider
                                                                  .detailsAttendance[
                                                                      i]
                                                                  .statusColorCode !=
                                                              true &&
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
                                                textAlign: TextAlign.end,
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
    width: screenWidth * 0.44, // 45% of screen width
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
