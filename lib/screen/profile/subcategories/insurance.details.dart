import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/custom_appbar.dart';
import 'package:hrms_app/models/profiles.models.dart';
import 'package:hrms_app/providers/profile_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class InsuranceDetails extends StatefulWidget {
  @override
  State<InsuranceDetails> createState() => _InsuranceDetailsState();
}

class _InsuranceDetailsState extends State<InsuranceDetails> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Provider.of<EmployeeProvider>(context, listen: false)
          .fetchEmployeeDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    if (employeeProvider.isLoading) {
      return Scaffold(
        appBar: CustomAppBar(title: "Insurance Details"),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Function to format date
    String formatDate(String dateString) {
      if (dateString == 'N/A' || dateString.isEmpty) return "N/A";

      try {
        DateTime parsedDate = DateTime.parse(dateString);
        return DateFormat('d MMM yyyy')
            .format(parsedDate); // Output: 5 Mar 2025
      } catch (e) {
        return "Invalid Date";
      }
    }

    final insuranceDetail = employeeProvider.insuranceDetail ??
        EmployeeInsuranceDetail(
          type: 'null',
          enddate: 'null',
          startdate: 'null',
          policyNumber: 'null',
          employeeName: 'null',
          amount: 'null',
          isIncomeTaxExceptionApplicable: 'null',
        );

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "Insurance Details"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insuranceDetail.type,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 16),

                  // ✅ Fixed the error: Changed __buildInfoRow to _buildInfoRow
                  _buildInfoRow(
                    "Income Tax Exemption Available",
                    insuranceDetail.isIncomeTaxExceptionApplicable
                                .toLowerCase() ==
                            'true'
                        ? "Yes"
                        : "No",
                  ),

                  _buildInfoRow("Policy Number", insuranceDetail.policyNumber),
                  _buildInfoRow("Insurer", insuranceDetail.employeeName),
                  _buildInfoRow(
                      "From Date", formatDate(insuranceDetail.startdate)),
                  _buildInfoRow("To Date", formatDate(insuranceDetail.enddate)),
                  _buildInfoRow("Amount", insuranceDetail.amount),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// **Reusable method for displaying key-value pairs in the card**
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: TextStyle(
                fontSize: 16,
                color: textColor.withOpacity(0.7),
                fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // Ensures long texts don't break layout
            ),
          ),
        ],
      ),
    );
  }
}
