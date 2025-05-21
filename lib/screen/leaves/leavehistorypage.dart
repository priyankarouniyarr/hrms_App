import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/widget/dropdown_custom.dart';
import 'package:hrms_app/providers/leaves_provider/leaves_history%20_contract%20and%20fiscalyear_period.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class LeaveStatementScreen extends StatefulWidget {
  @override
  _LeaveStatementScreenState createState() => _LeaveStatementScreenState();
}

class _LeaveStatementScreenState extends State<LeaveStatementScreen> {
  int? selectedContractPeriod;
  int? selectedFiscalYear;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<LeaveContractandFiscalYearProvider>(context, listen: false)
          .fetchLeaveContracts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider =
        Provider.of<LeaveContractandFiscalYearProvider>(context);

    List<Map<String, dynamic>> contractPeriod = leaveProvider.leaveContractList
        .map((contract) =>
            {'label': contract.text, 'value': int.parse(contract.value)})
        .toList();

    List<Map<String, dynamic>> fiscalYear = leaveProvider.leaveFiscalYearList
        .map((fiscal) =>
            {'label': fiscal.text, 'value': int.parse(fiscal.value)})
        .toList();

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "Leave Statements"),
      body: SafeArea(
          child: leaveProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Contract Period Dropdown
                        const Text('Contract Period',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 8),
                        CustomDropdown2(
                          value: selectedContractPeriod,
                          items: contractPeriod,
                          hintText: 'Select a period',
                          onChanged: (value) {
                            setState(() {
                              selectedContractPeriod = value;
                              selectedFiscalYear = null;
                            });
                            if (selectedContractPeriod != null) {
                              leaveProvider.fetchFiscalYearByContractId(
                                contractId: selectedContractPeriod!,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        // Fiscal Year Dropdown
                        const Text('Fiscal Year',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 8),
                        CustomDropdown2(
                          value: selectedFiscalYear,
                          items: fiscalYear,
                          hintText: 'Select a fiscal year',
                          onChanged: (value) {
                            setState(() {
                              selectedFiscalYear = value;
                            });
                            if (selectedContractPeriod != null &&
                                selectedFiscalYear != null) {
                              leaveProvider
                                  .fetchFiscalYearByContractIdandFiscalYearId(
                                contractId: selectedContractPeriod!,
                                fiscalYearId: selectedFiscalYear!,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        // Showing Table and Leave Details Only if both are selected
                        if (selectedContractPeriod != null &&
                            selectedFiscalYear != null) ...[
                          const Divider(color: primarySwatch, thickness: 1.5),
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(2),
                              2: FlexColumnWidth(2),
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
                              ...leaveProvider.leavefiscalandcontractId
                                  .map((leave) {
                                return _buildTableRow(
                                    leave.leaveType,
                                    '${leave.balance.toInt()}',
                                    '${leave.allocated.toInt()}');
                              }).toList(),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text('Leaves',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 8),
                          leaveProvider.leavecontractandfiscalIdDetails.isEmpty
                              ? const Center(child: Text('No leave found.'))
                              : Column(
                                  children: leaveProvider
                                      .leavecontractandfiscalIdDetails
                                      .map((leave) {
                                    return Card(
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
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Leave Type
                                              Text(
                                                ' ${leave.leaveTypeName}',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              SizedBox(height: 8.0),

                                              // Dates
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Dates",
                                                    style: TextStyle(
                                                        fontSize: 14.0),
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "To From",
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                  Text(
                                                    '${DateFormat('yyyy-MM-dd').format(DateTime.parse(leave.toDate))}',
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "No of Days",
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                  Text(
                                                    ' ${leave.totalLeaveDays.toDouble()}',
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Request Date",
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                  Text(
                                                    '  ${DateFormat('yyyy-MM-dd').format(DateTime.parse(leave.applicationDate))}',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Reason",
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                  Text(
                                                    ' ${leave.reason}',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: 8.0),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Approval By",
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                  Text(
                                                    leave.leaveApprovedBy !=
                                                            null
                                                        ? ' ${leave.leaveApprovedBy}'
                                                        : 'N/A',
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Approval Date",
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                  Text(
                                                    leave.leaveApprovedOn
                                                            is DateTime
                                                        ? DateFormat(
                                                                'yyyy-MM-dd')
                                                            .format(leave
                                                                    .leaveApprovedOn
                                                                as DateTime)
                                                        : (leave.leaveApprovedOn !=
                                                                null
                                                            ? DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(DateTime
                                                                    .parse(leave
                                                                        .leaveApprovedOn))
                                                            : '-'),
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.0),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Substitute ",
                                                    style: TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                  Text(
                                                    leave.substituteEmployeeName !=
                                                            null
                                                        ? ' ${leave.substituteEmployeeName}'
                                                        : '-',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: 8.0),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Status',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    ' ${leave.status}',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (leave.extendedFromDate !=
                                                      null &&
                                                  leave.extendedToDate !=
                                                      null) ...[
                                                const SizedBox(height: 8),
                                                const Text(
                                                    "Extended Leave Details",
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Leave From",
                                                      style: TextStyle(
                                                          fontSize: 14.0),
                                                    ),
                                                    Text(
                                                      leave.extendedFromDate
                                                              is DateTime
                                                          ? DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(leave
                                                                      .leaveApprovedOn
                                                                  as DateTime)
                                                          : (leave.extendedFromDate !=
                                                                  null
                                                              ? DateFormat(
                                                                      'yyyy-MM-dd')
                                                                  .format(DateTime
                                                                      .parse(leave
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "To Date",
                                                      style: TextStyle(
                                                          fontSize: 14.0),
                                                    ),
                                                    Text(
                                                      leave.extendedToDate
                                                              is DateTime
                                                          ? DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(leave
                                                                      .extendedToDate
                                                                  as DateTime)
                                                          : (leave.extendedToDate !=
                                                                  null
                                                              ? DateFormat(
                                                                      'yyyy-MM-dd')
                                                                  .format(DateTime
                                                                      .parse(leave
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0,
                                                          right: 0.0),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
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
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ]),
                                                ),
                                              ],
                                            ],
                                          )),
                                    );
                                  }).toList(),
                                ),
                        ]
                      ]),
                )),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: primarySwatch)),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
