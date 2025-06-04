import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class WorkingExperience extends StatefulWidget {
  @override
  State<WorkingExperience> createState() => _WorkingExperienceState();
}

class _WorkingExperienceState extends State<WorkingExperience> {
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
    final workProvider = context.watch<EmployeeProvider>();

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: const CustomAppBarProfile(title: "Working Experience "),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: workProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : workProvider.experience.isEmpty
                ? const Center(child: Text("No experience"))
                : ListView.builder(
                    itemCount: workProvider.experience.length,
                    itemBuilder: (context, index) {
                      final experienceDetails = workProvider.experience[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: cardBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                _buildInfoRow(
                                    "Company", experienceDetails.company),
                                _buildInfoRow(
                                    "Address", experienceDetails.address),
                                _buildInfoRow("Designation",
                                    experienceDetails.designation),
                                _buildInfoRow(
                                  "Joining Date",
                                  experienceDetails.joiningDate
                                      .toString()
                                      .substring(0, 10),
                                ),
                                _buildInfoRow(
                                  "Leaving Date",
                                  experienceDetails.leavingDate
                                      .toString()
                                      .substring(0, 10),
                                ),
                                _buildInfoRow("Total Experience",
                                    experienceDetails.totalExperience),
                              ],
                            ),
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
