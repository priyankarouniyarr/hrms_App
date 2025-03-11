import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/custom_appbar.dart';
import 'package:hrms_app/models/profiles.models.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
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

  String formatDate(String dateString) {
    if (dateString == 'N/A' || dateString.isEmpty) return "N/A";

    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('d MMM yyyy').format(parsedDate); // Output: 5 Mar 2025
    } catch (e) {
      return "Invalid Date";
    }
  }

  @override
  Widget build(BuildContext context) {
    final insuranceProvider = context.watch<EmployeeProvider>();

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: const CustomAppBarProfile(title: "Insurance Details"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: insuranceProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : insuranceProvider.insurance.isEmpty
                ? const Center(child: Text(""))
                : ListView.builder(
                    itemCount: insuranceProvider.insurance.length,
                    itemBuilder: (context, index) {
                      EmployeeInsuranceDetail insuranceDetail =
                          insuranceProvider.insurance[index];
                      return Card(
                        color: cardBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                insuranceDetail.type,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 16),
                              _buildInfoRow(
                                "Income Tax Exemption Available",
                                insuranceDetail.isIncomeTaxExceptionApplicable
                                            .toLowerCase() ==
                                        'true'
                                    ? "Yes"
                                    : "No",
                              ),
                              _buildInfoRow("Company", insuranceDetail.company),
                              _buildInfoRow("Policy Number",
                                  insuranceDetail.policyNumber),
                              _buildInfoRow(
                                  "Insurer", insuranceDetail.employeeName),
                              _buildInfoRow("From Date",
                                  formatDate(insuranceDetail.startdate)),
                              _buildInfoRow("To Date",
                                  formatDate(insuranceDetail.enddate)),
                              _buildInfoRow("Amount", insuranceDetail.amount),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
  // Function to format date

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
