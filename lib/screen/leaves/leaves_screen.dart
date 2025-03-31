import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/custom_appbar.dart';
import 'package:hrms_app/screen/leaves/leavehistorypage.dart';
import 'package:hrms_app/models/leaves/leave_history_models.dart';
import 'package:hrms_app/screen/leaves/leaves_requestscreen.dart';
import 'package:hrms_app/providers/leaves_provider/leavehistory_provider.dart';

class LeavesScreen extends StatefulWidget {
  @override
  _LeavesScreenState createState() => _LeavesScreenState();
}

class _LeavesScreenState extends State<LeavesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch leave data when the screen loads
    Future.microtask(() => Provider.of<LeaveProvider>(context, listen: false)
        .fetchEmployeeLeaveHistory());
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBar(title: "Leaves"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(3), // Title column
                    1: FlexColumnWidth(2), // Available column
                    2: FlexColumnWidth(2), // Total column
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: primarySwatch.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      children: [
                        _buildTableHeader('Title'),
                        _buildTableHeader('Available'),
                        _buildTableHeader('Total'),
                      ],
                    ),
                    ...leaveProvider.leaves.map((leave) {
                      return _buildTableRow(
                          leave.leaveType,
                          '${leave.balance.toInt()}',
                          '${leave.allocated.toInt()}');
                    }).toList(),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeavesRequestscreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: primarySwatch[900],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Apply Leave',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: cardBackgroundColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Not Approved Leaves',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: leaveProvider.leaveNotApprovals.isEmpty
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('No approved leave requests found.'),
                      ))
                    : Column(
                        children: leaveProvider.leaveNotApprovals.map((leave) {
                          return Card(
                            color: Colors.white,
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: primarySwatch, width: 1),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Leave Type
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        leave.leaveTypeName,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        leave.status.toString(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: accentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),

                                  // Dates
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Leave From",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        DateFormat('yyyy-MM-dd').format(
                                          DateTime.parse(
                                              leave.fromDate.toString()),
                                        ),
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Leave To",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        DateFormat('yyyy-MM-dd').format(
                                              DateTime.parse(
                                                  leave.toDate.toString()),
                                            ) ??
                                            '-',
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),

                                  // Total Leave Days
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "No of Days",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        ('${leave.totalLeaveDays.toDouble()}'),
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),

                                  // Request Date
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Request Date",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        DateFormat('yyyy-MM-dd').format(
                                              DateTime.parse(leave
                                                  .applicationDate
                                                  .toString()),
                                            ) ??
                                            '-',
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  if (leave.extendedFromDate != null &&
                                      leave.extendedToDate != null) ...[
                                    const SizedBox(height: 8),
                                    const Text("Extended Leave Details",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Leave From",
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        Text(
                                          leave.extendedFromDate is DateTime
                                              ? DateFormat('yyyy-MM-dd').format(
                                                  leave.leaveApprovedOn
                                                      as DateTime)
                                              : (leave.extendedFromDate != null
                                                  ? DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.parse(
                                                          leave
                                                              .extendedFromDate))
                                                  : '-'),
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "To Date",
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        Text(
                                          leave.extendedToDate is DateTime
                                              ? DateFormat('yyyy-MM-dd').format(
                                                  leave.extendedToDate
                                                      as DateTime)
                                              : (leave.extendedToDate != null
                                                  ? DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.parse(
                                                          leave.extendedToDate))
                                                  : '-'),
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          " No of Days",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        Text(
                                          ' ${leave.extendedTotalLeaveDays.toDouble()}',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 0.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Leave Type",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            Text(
                                              ' ${leave.extendedLeaveTypeName}',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Approved Leaves',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: leaveProvider.leaveApprovals.isEmpty
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('No approved leave requests found.'),
                      ))
                    : Column(
                        children: leaveProvider.leaveApprovals.map((leave) {
                          return Card(
                            color: Colors.white,
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: primarySwatch, width: 1),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Leave Type
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          ' ${leave.leaveTypeName}',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          ' ${leave.status}',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 8.0),

                                    // Dates
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Leave From",
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        Text(
                                          '   ${DateFormat('yyyy-MM-dd').format(DateTime.parse(leave.fromDate))} ',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "To From",
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        Text(
                                          '${DateFormat('yyyy-MM-dd').format(DateTime.parse(leave.toDate)) ?? '-'}',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.0),

                                    // Total Leave Days
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "No of Days",
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        Text(
                                          ' ${leave.totalLeaveDays.toInt()}',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.0),

                                    // Request Date
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Request Date",
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        Text(
                                          '  ${DateFormat('yyyy-MM-dd').format(DateTime.parse(leave.applicationDate)) ?? '-'}',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.0),

                                    // Approval Date
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Approval Date",
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        Text(
                                          leave.leaveApprovedOn is DateTime
                                              ? DateFormat('yyyy-MM-dd').format(
                                                  leave.leaveApprovedOn
                                                      as DateTime)
                                              : (leave.leaveApprovedOn != null
                                                  ? DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.parse(
                                                          leave
                                                              .leaveApprovedOn))
                                                  : '-'),
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (leave.extendedFromDate != null &&
                                        leave.extendedToDate != null) ...[
                                      const SizedBox(height: 8),
                                      const Text("Extended Leave Details",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Leave From",
                                            style: TextStyle(fontSize: 14.0),
                                          ),
                                          Text(
                                            leave.extendedFromDate is DateTime
                                                ? DateFormat('yyyy-MM-dd')
                                                    .format(
                                                        leave.leaveApprovedOn
                                                            as DateTime)
                                                : (leave.extendedFromDate !=
                                                        null
                                                    ? DateFormat('yyyy-MM-dd')
                                                        .format(DateTime.parse(
                                                            leave
                                                                .extendedFromDate))
                                                    : '-'),
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "To Date",
                                            style: TextStyle(fontSize: 14.0),
                                          ),
                                          Text(
                                            leave.extendedToDate is DateTime
                                                ? DateFormat('yyyy-MM-dd')
                                                    .format(leave.extendedToDate
                                                        as DateTime)
                                                : (leave.extendedToDate != null
                                                    ? DateFormat('yyyy-MM-dd')
                                                        .format(DateTime.parse(
                                                            leave
                                                                .extendedToDate))
                                                    : '-'),
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            " No of Days",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          Text(
                                            ' ${leave.extendedTotalLeaveDays.toInt()}',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 0.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Leave Type",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              Text(
                                                ' ${leave.extendedLeaveTypeName}',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ],
                                )),
                          );
                        }).toList(),
                      ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaveStatementScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      color: primarySwatch[900],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'View Leave Statements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cardBackgroundColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String title, String available, String total) {
    return TableRow(
      children: [
        _buildTableCell(title),
        _buildTableCell(available),
        _buildTableCell(total),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
