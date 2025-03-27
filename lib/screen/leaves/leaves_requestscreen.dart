import 'package:intl/intl.dart';
import 'customtextfieldform.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/models/leaves/leave_request_models.dart';
import 'package:hrms_app/models/leaves/leave_history_models.dart';
import 'package:hrms_app/providers/leaves_provider/leavehistory_provider.dart';
import 'package:hrms_app/providers/leaves_provider/leave_request_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class LeavesRequestscreen extends StatefulWidget {
  const LeavesRequestscreen({super.key});

  @override
  State<LeavesRequestscreen> createState() => _LeavesRequestscreenState();
}

class _LeavesRequestscreenState extends State<LeavesRequestscreen> {
  TextEditingController _primarystartcontroller = TextEditingController();
  TextEditingController _primaryenddatecontroller = TextEditingController();
  TextEditingController _extendedstartcontroller = TextEditingController();
  TextEditingController _extendedenddatecontroller = TextEditingController();
  DateTime? _startDate;
  int? _selectedPrimaryleaveType;
  int? _selectedExtendedleaveType;
  int? _selectedSubstitudeEmployee;
  String? _selectedhalfday;
  @override
  void initState() {
    super.initState();
    // Fetch leave data when the screen loads
    Future.microtask(() => Provider.of<LeaveProvider>(context, listen: false)
        .fetchEmployeeLeaveHistory());
    Future.microtask(() =>
        Provider.of<LeaveRequestProvider>(context, listen: false)
            .fetchEmployeeLeaveApply());
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);
    final leaveRequest = Provider.of<LeaveRequestProvider>(context);
    // Filter and calculate available leaves
    final homeLeaves = leaveProvider.leaves
        .where((leave) => leave.leaveType == "Home Leave")
        .map((leave) => leave.balance.toInt())
        .toList();

    final sickLeaves = leaveProvider.leaves
        .where((leave) => leave.leaveType == "Sick Leave")
        .map((leave) => leave.balance.toInt())
        .toList();
    List<Map<String, dynamic>> leaveprimaryType = leaveRequest.leaveTypePrimary
        .map((primaryType) =>
            {'label': primaryType.text, 'value': int.parse(primaryType.value)})
        .toList();
    List<Map<String, dynamic>> leaveextendedType = leaveRequest
        .leaveTypeExtended
        .map((extendedType) => {
              'label': extendedType.text,
              'value': int.parse(extendedType.value)
            })
        .toList();
    List<Map<String, dynamic>> subStitude = leaveRequest.substitute
        .map((substitude) =>
            {'label': substitude.text, 'value': int.parse(substitude.value)})
        .toList();
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "Leave Request"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row for the two LeavesContainer widgets
                Row(
                  children: [
                    Expanded(
                      child: LeavesContainer(
                          title: "Home Leaves Available",
                          count: homeLeaves.isNotEmpty ? homeLeaves.first : 0),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: LeavesContainer(
                        title: "Sick Leaves Available",
                        count: sickLeaves.isNotEmpty ? sickLeaves.first : 0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 1.0,
                    dashLength: 4.0,
                    dashColor: Colors.black,
                    dashGapLength: 4.0,
                    dashGapColor: Colors.transparent,
                  ),
                ),
                SizedBox(height: 15),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Primary Shift Leave
                      Text(
                        "Primary Shift Leave",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Start Date and End Date
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
                                    controller: _primarystartcontroller,
                                    hintText: " Start date",
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now()
                                            .add(Duration(days: 1)),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _startDate = pickedDate;
                                          _primarystartcontroller.text =
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
                                    controller: _primaryenddatecontroller,
                                    hintText: "End date",
                                    readOnly: true,
                                    onTap: () async {
                                      if (_startDate == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Please select start date first",
                                              style: TextStyle(
                                                color: accentColor,
                                              ),
                                            ),
                                            backgroundColor:
                                                cardBackgroundColor,
                                          ),
                                        );
                                        return;
                                      }
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _startDate!.add(Duration(days: 1)),
                                        firstDate:
                                            _startDate!.add(Duration(days: 1)),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _primaryenddatecontroller.text =
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
                                      if (endDate
                                          .isAtSameMomentAs(_startDate!)) {
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
                      //leavetype
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Leave Type"),
                            SizedBox(height: 10),
                            CustomDropdown2(
                              value: _selectedPrimaryleaveType,
                              items: leaveprimaryType,
                              hintText: 'Select',
                              onChanged: (value) {
                                setState(() {
                                  _selectedPrimaryleaveType = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      //half day
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Half Day"),
                            SizedBox(height: 10),
                            CustomDropdown(
                              value: _selectedhalfday,
                              items: ['Yes', 'No'],
                              hintText: 'Select an option',
                              onChanged: (value) {
                                setState(() {
                                  _selectedhalfday = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      //extended shift leave
                      SizedBox(height: 10),
                      Text(
                        "Extended Shift Leave",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      //START AND END DATE
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
                                    controller: _extendedstartcontroller,
                                    hintText: " Start date",
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now()
                                            .add(Duration(days: 1)),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _startDate = pickedDate;
                                          _extendedstartcontroller.text =
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
                                    controller: _extendedenddatecontroller,
                                    hintText: "End date",
                                    readOnly: true,
                                    onTap: () async {
                                      if (_startDate == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Please select start date first",
                                              style: TextStyle(
                                                color: accentColor,
                                              ),
                                            ),
                                            backgroundColor:
                                                cardBackgroundColor,
                                          ),
                                        );
                                        return;
                                      }
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _startDate!.add(Duration(days: 1)),
                                        firstDate:
                                            _startDate!.add(Duration(days: 1)),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _extendedenddatecontroller.text =
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
                                      if (endDate
                                          .isAtSameMomentAs(_startDate!)) {
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
                      //extended leave type
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Leave Type"),
                            SizedBox(height: 10),
                            CustomDropdown2(
                              value: _selectedExtendedleaveType,
                              items: leaveextendedType,
                              hintText: 'Select',
                              onChanged: (value) {
                                setState(() {
                                  _selectedExtendedleaveType = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      //leave reason
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Reason"),
                            SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter a reason',
                                hintStyle: TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primarySwatch, width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primarySwatch, width: 2.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 10.0),
                                filled: true,
                                fillColor: cardBackgroundColor,
                              ),
                              cursorColor: primarySwatch[900],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      //SUBSTITUTE
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Substitute"),
                            SizedBox(height: 10),
                            CustomDropdown2(
                              value: _selectedSubstitudeEmployee,
                              items: subStitude,
                              hintText: 'Select',
                              onChanged: (value) {
                                setState(() {
                                  _selectedSubstitudeEmployee = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      //button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Apply Button
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                              decoration: BoxDecoration(
                                color: primarySwatch[900],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'Apply',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // Reset Button
                          InkWell(
                            onTap: () {
                              // Reset the form
                            },
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                              decoration: BoxDecoration(
                                color: primarySwatch[900],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on List<Leave> {
  get balance => null;
}

// LeavesContainer widget
class LeavesContainer extends StatelessWidget {
  final String title;
  final int count;

  const LeavesContainer({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: lightColor),
      ),
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(title),
            Text(
              "$count",
              style: TextStyle(
                color: primarySwatch[900],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
