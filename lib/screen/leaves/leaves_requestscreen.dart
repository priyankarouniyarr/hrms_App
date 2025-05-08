import 'package:intl/intl.dart';
import 'customtextfieldform.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/models/leaves/apply_leave.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/providers/leaves_provider/leavehistory_provider.dart';
import 'package:hrms_app/providers/leaves_provider/leave_request_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class LeavesRequestscreen extends StatefulWidget {
  const LeavesRequestscreen({super.key});

  @override
  State<LeavesRequestscreen> createState() => _LeavesRequestscreenState();
}

class _LeavesRequestscreenState extends State<LeavesRequestscreen> {
  final TextEditingController _primarystartcontroller = TextEditingController();
  final TextEditingController _primaryenddatecontroller =
      TextEditingController();
  final TextEditingController _extendedstartcontroller =
      TextEditingController();
  final TextEditingController _extendedenddatecontroller =
      TextEditingController();
  final TextEditingController _reasoncontroller = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _extendedDate;
  DateTime? _extendedEndDate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _selectedPrimaryleaveType;
  int? _selectedExtendedleaveType;
  int? _selectedSubstitudeEmployee;
  String? _selectedhalfday;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<LeaveProvider>(context, listen: false)
        .fetchEmployeeLeaveHistory(context));
    Future.microtask(() =>
        Provider.of<LeaveRequestProvider>(context, listen: false)
            .fetchEmployeeLeaveApply(context));
  }

  int calculateTotalLeaveDays(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays + 1;
  }

  int calculateTotalExtendedLeaveDays(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays + 1;
  }

  String convertToNepaliDate(DateTime gregorianDate) {
    final nepaliDate = gregorianDate.toNepaliDateTime();
    return '${nepaliDate.year}-${nepaliDate.month.toString().padLeft(2, '0')}-${nepaliDate.day.toString().padLeft(2, '0')}';
  }

  bool _validateForm() {
    // Validate primary leave fields
    if (_selectedPrimaryleaveType == null ||
        _startDate == null ||
        _endDate == null) {
      return false;
    }

    // Validate extended leave fields (if any are filled)
    if (_extendedDate != null ||
        _extendedEndDate != null ||
        _selectedExtendedleaveType != null) {
      if (_extendedDate == null ||
          _extendedEndDate == null ||
          _selectedExtendedleaveType == null) {
        return false;
      }
    }

    return true;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (!_validateForm()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please fill all required fields correctly',
              style: TextStyle(color: accentColor, fontSize: 16),
            ),
            backgroundColor: cardBackgroundColor,
          ),
        );
        return;
      }
//final extendedTotalLeaveDays = calculateTotalExtendedLeaveDays(_extendedDate!, _extendedEndDate!);
      final totalLeaveDays = calculateTotalLeaveDays(_startDate!, _endDate!);
      final fromDateNp = convertToNepaliDate(_startDate!);
      final formattedDate = fromDateNp.replaceAll('-', '/');
      final toDateNp = convertToNepaliDate(_endDate!);
      final formattedEndDate = toDateNp.replaceAll('-', '/');

      final leaveRequest = LeaveApplicationRequest(
        leaveTypeId: _selectedPrimaryleaveType!,
        fromDate: DateFormat('MM/dd/yyyy').format(_startDate!),
        toDate: DateFormat('MM/dd/yyyy').format(_endDate!),
        fromDateNp: formattedDate,
        toDateNp: formattedEndDate,
        totalLeaveDays: totalLeaveDays,
        reason:
            _reasoncontroller.text.isNotEmpty ? _reasoncontroller.text : null,
        substituteEmployeeId: _selectedSubstitudeEmployee!,
        extendedLeaveTypeId: _selectedExtendedleaveType,
        extendedFromDate: _extendedDate != null
            ? DateFormat('MM/dd/yyyy').format(_extendedDate!)
            : null,
        extendedToDate: _extendedEndDate != null
            ? DateFormat('MM/dd/yyyy').format(_extendedEndDate!)
            : null,
        extendedFromDateNp: _extendedDate != null
            ? convertToNepaliDate(_extendedDate!).replaceAll('-', '/')
            : null,
        extendedToDateNp: _extendedEndDate != null
            ? convertToNepaliDate(_extendedEndDate!).replaceAll('-', '/')
            : null,
        //  extendedTotalLeaveDays: extendedTotalLeaveDays.toDouble(),
        halfDayStatus: _selectedhalfday,
        isHalfDay: _selectedhalfday == 'Both' || _selectedhalfday == 'On Start'
            ? true
            : false,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Leave Request'),
          content: const Text('Are you sure you want to apply for leave?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog first

                final success = await Provider.of<LeaveRequestProvider>(context,
                        listen: false)
                    .leaveApplyEmployee(leaveRequest, context);

                if (success) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Success"),
                        content: const Text(
                          "Leave Applied Successfully!",
                          style: TextStyle(fontSize: 18, color: Colors.green),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                              _resetForm(); // Reset the form
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to apply leave: ${Provider.of<LeaveRequestProvider>(context, listen: false).errorMessage}',
                        style: const TextStyle(color: Colors.red, fontSize: 20),
                      ),
                      backgroundColor: cardBackgroundColor,
                    ),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _extendedenddatecontroller.clear();
      _extendedstartcontroller.clear();
      _primaryenddatecontroller.clear();
      _primarystartcontroller.clear();
      _reasoncontroller.clear();
      _selectedPrimaryleaveType = null;
      _selectedExtendedleaveType = null;
      _selectedSubstitudeEmployee = null;
      _selectedhalfday = null;
      _startDate = null;
      _endDate = null;
      _extendedDate = null;
      _extendedEndDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);
    final leaveRequest = Provider.of<LeaveRequestProvider>(context);

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
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Primary Shift Leave",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Start Date",
                                      style: TextStyle(fontSize: 16)),
                                  SizedBox(height: 5),
                                  CustomTextFormField(
                                    controller: _primarystartcontroller,
                                    hintText: "Start date",
                                    readOnly: true,
                                    validator: (value) => _startDate == null
                                        ? 'Start date is required'
                                        : null,
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
                                          // Clear end date if new start date is after current end date
                                          if (_endDate != null &&
                                              _endDate!.isBefore(pickedDate)) {
                                            _endDate = null;
                                            _primaryenddatecontroller.clear();
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("End Date",
                                      style: TextStyle(fontSize: 16)),
                                  SizedBox(height: 5),
                                  CustomTextFormField(
                                    controller: _primaryenddatecontroller,
                                    hintText: "End date",
                                    readOnly: true,
                                    validator: (value) => _endDate == null
                                        ? 'End date is required'
                                        : (_startDate != null &&
                                                _endDate!.isBefore(_startDate!))
                                            ? 'End date must be after start date'
                                            : null,
                                    onTap: () async {
                                      _formKey.currentState?.validate();
                                      if (_startDate == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Please select start date first",
                                              style:
                                                  TextStyle(color: accentColor),
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
                                        firstDate: _startDate!,
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _endDate = pickedDate;
                                          _primaryenddatecontroller.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          _formKey.currentState?.validate();
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
                              validator: (value) => value == null
                                  ? 'Leave type is required'
                                  : null,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Half Day"),
                            SizedBox(height: 10),
                            CustomDropdown(
                              value: _selectedhalfday,
                              items: ['On Start', 'On End', 'Both'],
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
                      SizedBox(height: 10),
                      Text(
                        "Extended Shift Leave",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Start Date",
                                      style: TextStyle(fontSize: 16)),
                                  SizedBox(height: 5),
                                  CustomTextFormField(
                                    controller: _extendedstartcontroller,
                                    hintText: "Start date",
                                    readOnly: true,
                                    validator: (value) {
                                      if (_extendedEndDate != null &&
                                          _extendedDate == null) {
                                        return 'Start date is required';
                                      }
                                      return null;
                                    },
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
                                          _extendedDate = pickedDate;
                                          _extendedstartcontroller.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          // Clear end date if new start date is after current end date
                                          if (_extendedEndDate != null &&
                                              _extendedEndDate!
                                                  .isBefore(pickedDate)) {
                                            _extendedEndDate = null;
                                            _extendedenddatecontroller.clear();
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("End Date",
                                      style: TextStyle(fontSize: 16)),
                                  SizedBox(height: 5),
                                  CustomTextFormField(
                                    controller: _extendedenddatecontroller,
                                    hintText: "End date",
                                    readOnly: true,
                                    validator: (value) {
                                      if (_extendedDate != null &&
                                          _extendedEndDate == null) {
                                        return 'End date is required';
                                      }
                                      if (_extendedDate != null &&
                                          _extendedEndDate != null &&
                                          _extendedEndDate!
                                              .isBefore(_extendedDate!)) {
                                        return 'End date must be after start date';
                                      }
                                      return null;
                                    },
                                    onTap: () async {
                                      _formKey.currentState?.validate();
                                      if (_extendedDate == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Please select start date first",
                                              style:
                                                  TextStyle(color: accentColor),
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
                                        initialDate: _extendedDate!
                                            .add(Duration(days: 1)),
                                        firstDate: _extendedDate!,
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _extendedEndDate = pickedDate;
                                          _extendedenddatecontroller.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          _formKey.currentState?.validate();
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
                              validator: (value) {
                                if ((_extendedDate != null ||
                                        _extendedEndDate != null) &&
                                    value == null) {
                                  return 'Leave type is required';
                                }
                                return null;
                              },
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Reason"),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _reasoncontroller,
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
                      SizedBox(height: 10),
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
                              validator: (value) => value == null
                                  ? 'Substitute is required'
                                  : null,
                              onChanged: (value) {
                                setState(() {
                                  _selectedSubstitudeEmployee = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: _submitForm,
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 50.0,
                              ),
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
                          InkWell(
                            onTap: _resetForm,
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 50.0),
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
