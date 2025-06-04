import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class Workshiftinformation extends StatefulWidget {
  Workshiftinformation({super.key});

  @override
  State<Workshiftinformation> createState() => _WorkshiftinformationState();
}

class _WorkshiftinformationState extends State<Workshiftinformation> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Provider.of<EmployeeProvider>(context, listen: false)
          .fetchEmployeeDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    if (employeeProvider.isLoading) {
      return Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: CustomAppBarProfile(title: "Work and Shift Information"),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "Work and Shift Information"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shift Information
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Shift Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),
              // Work Details Card
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: cardBackgroundColor,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                            "Primary ShiftName",
                            employeeProvider.currentShift.primaryShiftName ??
                                "N/A"),
                        _buildInfoRow("Primary Shift Time",
                            "${_formatTime(employeeProvider.currentShift.primaryShiftStart)} - ${_formatTime(employeeProvider.currentShift.primaryShiftEnd)}"),
                        if (employeeProvider.currentShift.hasMultiShift ==
                            true) ...[
                          _buildInfoRow(
                              "ExtendedShift Name",
                              employeeProvider.currentShift.extendedShiftName ??
                                  "N/A"),
                          _buildInfoRow("ExtendedShift Time",
                              "${_formatTime(employeeProvider.currentShift.extendedShiftStart)} - ${_formatTime(employeeProvider.currentShift.extendedShiftEnd)}"),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Work Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),
              // Work Details Card
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: cardBackgroundColor,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow("Branch", employeeProvider.branch),
                          _buildInfoRow(
                              "Department", employeeProvider.department),
                          _buildInfoRow(
                              "Designation", employeeProvider.desgination),
                          _buildInfoRow("Date of Joining",
                              employeeProvider.dateOfJoining),
                          _buildInfoRow("Phone Number", employeeProvider.phone),
                          _buildInfoRow("Email", employeeProvider.email),
                        ]),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Authorities",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: cardBackgroundColor,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                              "Supervisor", employeeProvider.managerTitle),
                          _buildInfoRow("Expense Approver",
                              employeeProvider.expenseApproverTitle),
                          _buildInfoRow("Time off Approver",
                              employeeProvider.timeoffApproverTitle),
                          _buildInfoRow("Coach", employeeProvider.coachTitle),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return "N/A";

    try {
      final parsedTime = DateTime.parse(time);
      return DateFormat("HH:mm").format(parsedTime); // Formats to hh:mm
    } catch (e) {
      return "N/A"; // In case of parsing errors, return N/A
    }
  }

  /// **Reusable method for displaying key-value pairs inside a card**
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 30),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 8.0),
              child: Text(
                value,
                style: TextStyle(fontSize: 14),
                softWrap: true,
                // overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                // Aligns text to the right
              ),
            ),
          ),
        ],
      ),
    );
  }
}
