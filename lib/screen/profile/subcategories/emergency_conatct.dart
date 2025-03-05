import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/profile_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
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
    final employeeProvider = context.watch<EmployeeProvider>();

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(
          title: "EmergencyContact"), // Customize color as needed

      body: employeeProvider.isLoading
          ? Center(child: CircularProgressIndicator()) // Simple loading spinner
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact Person
                    _buildInfoRow(
                      title: "Contact Person",
                      content: employeeProvider
                              .emergenecycontact.contactPerson.isNotEmpty
                          ? employeeProvider.emergenecycontact.contactPerson
                          : "null",
                    ),

                    // Phone Number
                    _buildInfoRow(
                      title: "Phone Number",
                      content: employeeProvider
                              .emergenecycontact.phoneNumber.isNotEmpty
                          ? employeeProvider.emergenecycontact.phoneNumber
                          : "null",
                    ),

                    // Relation
                    _buildInfoRow(
                      title: "Relation",
                      content:
                          employeeProvider.emergenecycontact.relation.isNotEmpty
                              ? employeeProvider.emergenecycontact.relation
                              : "null",
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Helper Widget to build each info row within the single card
  Widget _buildInfoRow({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$title:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(width: 10), // Space between title and content
          Text(
            content,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
