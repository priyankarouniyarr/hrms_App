import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class LeaveStatementScreen extends StatefulWidget {
  @override
  _LeaveStatementScreenState createState() => _LeaveStatementScreenState();
}

class _LeaveStatementScreenState extends State<LeaveStatementScreen> {
  String? selectedPeriod;
  String? selectedFiscalYear;

  @override
  Widget build(BuildContext context) {
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
                items: ['2024', '2023', '2022'],
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
                items: ['2024-25', '2023-24', '2022-23'],
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
