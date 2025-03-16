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
  String? selectedPeriod;
  String? selectedFiscalYear;
  @override
  void initState() {
    super.initState();
    // Fetch data when the screen is loaded
    final leaveProvider =
        Provider.of<LeaveContractandFiscalYearProvider>(context, listen: false);
    leaveProvider.fetchEmployeeLeaveHistory();
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider =
        Provider.of<LeaveContractandFiscalYearProvider>(context);

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: const CustomAppBarProfile(title: "Leave Statement"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contract Period Dropdown
            const Text(
              'Contract Period',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            CustomDropdown(
                value: selectedPeriod,
                items: leaveProvider.leaveContractYear
                    .map((item) => item.text)
                    .toList(),
                hintText: 'Select a period',
                onChanged: (value) {
                  setState(() {
                    selectedPeriod = value;
                  });
                }),

            const SizedBox(height: 20),

            // Fiscal Year Dropdown
            const Text(
              'Fiscal Year',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            CustomDropdown(
                value: selectedFiscalYear,
                items: leaveProvider.leaveFiscalYear
                    .map((item) => item.text)
                    .toList(),
                hintText: 'Select a fiscal year',
                onChanged: (value) {
                  setState(() {
                    selectedFiscalYear = value;
                  });
                }),

            const SizedBox(height: 20),
            const Divider(),

            // Leaves Section details
            const Text(
              'Leaves',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'No leaves found.',
              style: TextStyle(color: Colors.black.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }
}
