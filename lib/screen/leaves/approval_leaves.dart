import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/leaves_provider/leavehistory_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen categories/customprofile_appbar.dart';

class ApprovalLeaves extends StatefulWidget {
  const ApprovalLeaves({super.key});

  @override
  State<ApprovalLeaves> createState() => _ApprovalLeavesState();
}

class _ApprovalLeavesState extends State<ApprovalLeaves> {
  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);

    return Scaffold(
      appBar: CustomAppBarProfile(title: "Approval Leaves"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: leaveProvider.leaveApprovals.isEmpty
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.all(30),
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
                                          '${DateFormat('yyyy-MM-dd').format(DateTime.parse(leave.toDate))
                                          //?? '-'
                                          }',
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
                                          '  ${DateFormat('yyyy-MM-dd').format(DateTime.parse(leave.applicationDate))
                                          //?? '-'
                                          }',
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
            ],
          ),
        ),
      ),
    );
  }
}
