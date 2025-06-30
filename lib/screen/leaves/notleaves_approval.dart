import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/widget/customtextfieldform.dart';
import 'package:hrms_app/providers/leaves_provider/leavehistory_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen categories/customprofile_appbar.dart';

class NotApprovalLeaves extends StatefulWidget {
  const NotApprovalLeaves({super.key});

  @override
  State<NotApprovalLeaves> createState() => _NotApprovalLeavesState();
}

class _NotApprovalLeavesState extends State<NotApprovalLeaves> {
  // String? _selectedStatus = "Open";
  // final TextEditingController _primarystartcontroller = TextEditingController();
  // final TextEditingController _primaryenddatecontroller =
  //     TextEditingController();

  // DateTime? _startDate;
  // DateTime? _endDate;

  // bool _isInitialized = false;
  // bool _isLoading = false;
  @override
  // void initState() {
  //   super.initState();
  //   // final DateTime now = DateTime.now();
  //   // final DateTime oneMonthsAgo = DateTime(now.year, now.month - 1, now.day);
  //   // _startDate = oneMonthsAgo;
  //   // _endDate = now;
  //   // _primarystartcontroller.text =
  //   //     DateFormat('yyyy-MM-dd').format(oneMonthsAgo);
  //   // _primaryenddatecontroller.text = DateFormat('yyyy-MM-dd').format(now);
  //   // WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
  // }

  // @override
  // void dispose() {
  //   _primarystartcontroller.dispose();
  //   _primaryenddatecontroller.dispose();
  //   super.dispose();
  // }

  // Future<void> _initializeData() async {
  //   setState(() => _isLoading = true);

  //final requestTicket = NotApprovalLeaves(

  // status: _selectedStatus ?? "",

  // fromdate: _primarystartcontroller.text,
  // todate: _primaryenddatecontroller.text,

  //       );
  //   try {} catch (e) {
  //     print(e);

  //     // Handle error if needed
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //         _isInitialized = true;
  //       });
  //     }
  //   }
  // }

  // void _applyFilters() {
  //   setState(() => _isInitialized = false);
  // }

  // void _clearFilters() {
  //   final now = DateTime.now();
  //   final oneMonthsAgo = DateTime(now.year, now.month - 1, now.day);
  //   setState(() {
  //     _selectedStatus = "Open";
  //     _startDate = oneMonthsAgo;
  //     _endDate = now;
  //     _primarystartcontroller.text =
  //         DateFormat('yyyy-MM-dd').format(oneMonthsAgo);
  //     _primaryenddatecontroller.text = DateFormat('yyyy-MM-dd').format(now);
  //   });
  //   _applyFilters();
  // }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);

    return Scaffold(
      appBar: CustomAppBarProfile(title: "Not Approved Leaves"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //     _buildFilterSection(),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: leaveProvider.leaveNotApprovals.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('No approved leave requests found.'),
                        ),
                      )
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
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        leave.leaveTypeName,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        leave.status.toString(),
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: accentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  _buildRow(
                                      "Leave From",
                                      DateFormat('yyyy-MM-dd').format(
                                          DateTime.parse(
                                              leave.fromDate.toString()))),
                                  const SizedBox(height: 8.0),
                                  _buildRow(
                                      "Leave To",
                                      DateFormat('yyyy-MM-dd').format(
                                          DateTime.parse(
                                              leave.toDate.toString()))),
                                  const SizedBox(height: 8.0),
                                  _buildRow("No of Days",
                                      '${leave.totalLeaveDays.toDouble()}'),
                                  const SizedBox(height: 8.0),
                                  _buildRow(
                                      "Request Date",
                                      DateFormat('yyyy-MM-dd').format(
                                          DateTime.parse(leave.applicationDate
                                              .toString()))),
                                  if (leave.extendedFromDate != null &&
                                      leave.extendedToDate != null) ...[
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Extended Leave Details",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildRow(
                                      "Leave From",
                                      leave.extendedFromDate != null
                                          ? DateFormat('yyyy-MM-dd').format(
                                              DateTime.parse(
                                                  leave.extendedFromDate))
                                          : '-',
                                    ),
                                    const SizedBox(height: 8.0),
                                    _buildRow(
                                      "To Date",
                                      leave.extendedToDate != null
                                          ? DateFormat('yyyy-MM-dd').format(
                                              DateTime.parse(
                                                  leave.extendedToDate))
                                          : '-',
                                    ),
                                    const SizedBox(height: 8.0),
                                    _buildRow(
                                      "No of Days",
                                      '${leave.extendedTotalLeaveDays.toDouble()}',
                                    ),
                                    const SizedBox(height: 8.0),
                                    _buildRow("Leave Type",
                                        leave.extendedLeaveTypeName ?? '-',
                                        bold: true),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14.0)),
        Text(
          value,
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }

  // Widget _buildFilterSection() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             // If you want to include dropdown filters later, add them here
  //           ],
  //         ),
  //         Row(
  //           children: [
  // //             _buildDateField(
  // //               "Start Date",
  //               _primarystartcontroller,
  //               _startDate,
  //               (picked) {
  //                 setState(() {
  //                   _startDate = picked;
  //                   _primarystartcontroller.text =
  //                       DateFormat('yyyy-MM-dd').format(picked);
  //                   if (_endDate != null && _endDate!.isBefore(picked)) {
  //                     _endDate = null;
  //                     _primaryenddatecontroller.clear();
  //                   }
  //                 });
  //               },
  //             ),
  //             const SizedBox(width: 10),
  //             _buildDateField(
  //               "End Date",
  //               _primaryenddatecontroller,
  //               _endDate,
  //               (picked) {
  //                 setState(() {
  //                   _endDate = picked;
  //                   _primaryenddatecontroller.text =
  //                       DateFormat('yyyy-MM-dd').format(picked);
  //                 });
  //               },
  //               startDate: _startDate,
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 10),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             TextButton.icon(
  //               onPressed: _clearFilters,
  //               icon: const Icon(Icons.refresh, color: primarySwatch),
  //               label: const Text('Clear Filters',
  //                   style: TextStyle(color: primarySwatch)),
  //             ),
  //             ElevatedButton.icon(
  //               onPressed: _applyFilters,
  //               icon: const Icon(Icons.filter_alt),
  //               label: const Text("Apply"),
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: cardBackgroundColor,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                   side: const BorderSide(color: primarySwatch),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Expanded _buildDateField(
    String label,
    TextEditingController controller,
    DateTime? selectedDate,
    ValueChanged<DateTime> onPicked, {
    DateTime? startDate,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: primarySwatch,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          CustomTextFormField(
            controller: controller,
            readOnly: true,
            hintText: label,
            suffixIcon: const Icon(Icons.calendar_today,
                size: 12, color: primarySwatch),
            validator: (value) {
              if (selectedDate == null) return '$label is required';
              if (label == "End Date" &&
                  startDate != null &&
                  selectedDate.isBefore(startDate)) {
                return 'End date must be after start date';
              }
              return null;
            },
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: startDate ??
                    DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                onPicked(picked);
                //_applyFilters();
              }
            },
          ),
        ],
      ),
    );
  }
}
