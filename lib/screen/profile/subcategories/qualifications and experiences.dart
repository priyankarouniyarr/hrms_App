import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/profile/workingexperience.dart';
import 'package:hrms_app/models/profile_models/profiles.models.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class QualificationExpericence extends StatefulWidget {
  @override
  State<QualificationExpericence> createState() =>
      _QualificationExpericenceState();
}

class _QualificationExpericenceState extends State<QualificationExpericence> {
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
    final qualificationProvider = context.watch<EmployeeProvider>();

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: const CustomAppBarProfile(title: "Qualifications "),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: qualificationProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : qualificationProvider.quailfication.isEmpty
                ? const Center(child: Text("No qualifications"))
                : ListView.builder(
                    itemCount: qualificationProvider.quailfication.length,
                    itemBuilder: (context, index) {
                      EmployeeEducation qualificationdetails =
                          qualificationProvider.quailfication[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: cardBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ExpansionTile(
                            title: Text(
                              qualificationdetails.qualification,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            childrenPadding: const EdgeInsets.all(16.0),
                            children: [
                              _buildInfoRow(
                                  "School", qualificationdetails.school),
                              _buildInfoRow("Qualification",
                                  qualificationdetails.qualification),
                              _buildInfoRow(
                                  "Level", qualificationdetails.level),
                              _buildInfoRow("Passed Year",
                                  qualificationdetails.yearOfPassing),
                              _buildInfoRow("Percentage",
                                  qualificationdetails.percentageOrGrade),
                              _buildInfoRow("Major Optional Subject",
                                  qualificationdetails.majorOptionalSubject),
                              _buildInfoRow(
                                  "Division", qualificationdetails.division),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      // Removed incorrect usage of WorkingExperience
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
          SizedBox(
            width: 30,
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: textColor.withOpacity(0.7),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
