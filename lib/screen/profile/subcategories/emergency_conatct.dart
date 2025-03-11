import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/models/profiles.models.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: employeeProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : employeeProvider.emergenecycontact.isEmpty
                ? Center(child: Text("No emergency Contact Found"))
                : ListView.builder(
                    itemCount: employeeProvider.emergenecycontact.length,
                    itemBuilder: (context, index) {
                      EmployeeEmergencyContact emergencyContact =
                          employeeProvider.emergenecycontact[index];
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
                              SizedBox(height: 16),
                              _buildInfoRow("Contact Person",
                                  emergencyContact.contactPerson),
                              _buildInfoRow(
                                  "Phone Number", emergencyContact.phoneNumber),
                              _buildInfoRow(
                                  "Relation", emergencyContact.relation),
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
