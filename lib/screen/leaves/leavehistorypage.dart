import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
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
                              contractId: selectedContractPeriod!);
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
                                  fiscalYearId: selectedFiscalYear!);
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
                                  .map((leaveDetails) {
                                return _buildLeaveCard(leaveDetails);
                              }).toList(),
                            ),
                    ],
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

  Widget _buildLeaveCard(leaveDetails) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: primarySwatch, width: 2),
      ),
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(' ${leaveDetails.leaveTypeName}',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: primarySwatch)),
          const SizedBox(height: 8.0),
          _buildDetailRow("Dates",
              '${DateFormat('dd MMM, yyyy').format(leaveDetails.fromDate)} - ${DateFormat('dd MMM, yyyy').format(leaveDetails.toDate)}'),
          _buildDetailRow(
              "No of Days", '${leaveDetails.totalLeaveDays.toInt()}'),
          _buildDetailRow("Reason", leaveDetails.reason ?? 'N/A'),
          _buildDetailRow("Request Date",
              DateFormat('dd MMM, yyyy').format(leaveDetails.applicationDate)),
          _buildDetailRow("Approval By", leaveDetails.leaveApprovedBy ?? 'N/A'),
          _buildDetailRow("Approval Date", leaveDetails.leaveApprovedOn ?? '-'),
          _buildDetailRow(
              "Substitute", leaveDetails.substituteEmployeeName ?? 'N/A'),
          _buildDetailRow("Status", leaveDetails.status ?? '',
              color: leaveDetails.status == "Open"
                  ? Colors.red
                  : (leaveDetails.status == "Approved"
                      ? Colors.green
                      : accentColor)),

          // Extended Leave
          if (leaveDetails.extendedFromDate != null &&
              leaveDetails.extendedToDate != null) ...[
            const SizedBox(height: 8),
            const Text("Extended Leave Details",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildDetailRow(
                "Dates",
                '${DateFormat('dd MMM, yyyy').format(leaveDetails.extendedFromDate!)} - '
                    '${DateFormat('dd MMM, yyyy').format(leaveDetails.extendedToDate!)}'),
            _buildDetailRow("No of Days",
                '${leaveDetails.extendedTotalLeaveDays ?? 'N/A'}'),
            _buildDetailRow(
                "Leave Type Name", leaveDetails.extendedLeaveTypeName ?? 'N/A'),
          ],
        ]),
      ),
    );
  }

  // Reusable Detail Row
  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 14.0)),
        SizedBox(width: 20),
        Flexible(
          child: Text(
            value,
            style: TextStyle(fontSize: 14.0, color: color ?? Colors.black),
            textAlign: TextAlign.right,
          ),
        ),
      ]),
    );
  }
}
