import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/screen/leaves/customtextfieldform.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class AttendanceDetails extends StatefulWidget {
  const AttendanceDetails({super.key});

  @override
  State<AttendanceDetails> createState() => _AttendanceDetailsState();
}

class _AttendanceDetailsState extends State<AttendanceDetails> {
  String? _selectedShiftValue;
  TextEditingController _startdatecontroller = TextEditingController();
  TextEditingController _enddatecontroller = TextEditingController();
  DateTime? _startDate;

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                height: 10,
              ),
              CustomDropdown(
                value: _selectedShiftValue,
                items: ['Primary', 'Secondary'],
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
                          Text(
                            "Start Date",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          CustomTextFormField(
                            controller: _startdatecontroller,
                            hintText: " Start date",
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
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
                          Text(
                            "End Date",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          CustomTextFormField(
                            controller: _enddatecontroller,
                            hintText: "End date",
                            readOnly: true,
                            onTap: () async {
                              if (_startDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
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
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _enddatecontroller.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'End date is required';
                              }
                              DateTime endDate =
                                  DateFormat('yyyy-MM-dd').parse(value);
                              if (endDate.isAtSameMomentAs(_startDate!)) {
                                return 'End date cannot be the same as start date';
                              }
                              return null;
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
                  //functions will be show
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 200,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: primarySwatch[900],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        'Apply Filter',
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
              Text("No attendance details found",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.5),
                  )),
            ],
          ),
        ));
  }
}
