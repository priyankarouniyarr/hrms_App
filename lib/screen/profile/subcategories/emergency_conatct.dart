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
      appBar: CustomAppBarProfile(title: "Emergency Contact"),
      body: employeeProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spa,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    title: "Contact Person",
                    content: employeeProvider
                            .emergenecycontact.contactPerson.isNotEmpty
                        ? employeeProvider.emergenecycontact.contactPerson
                        : "N/A",
                  ),
                  Divider(), // A divider for separation
                  _buildInfoRow(
                    title: "Phone Number",
                    content: employeeProvider
                            .emergenecycontact.phoneNumber.isNotEmpty
                        ? employeeProvider.emergenecycontact.phoneNumber
                        : "N/A",
                  ),
                  Divider(),
                  _buildInfoRow(
                    title: "Relation",
                    content:
                        employeeProvider.emergenecycontact.relation.isNotEmpty
                            ? employeeProvider.emergenecycontact.relation
                            : "N/A",
                  ),
                ],
              ),
            ),
    );
  }

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
          SizedBox(width: 10),
          Expanded(
            child: Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.black87),
              overflow: TextOverflow.ellipsis, // Prevents overflow issues
            ),
          ),
        ],
      ),
    );
  }
}
