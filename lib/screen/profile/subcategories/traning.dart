import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/models/profile_models/profiles.models.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class Training extends StatefulWidget {
  @override
  State<Training> createState() => _TrainingState();
}

class _TrainingState extends State<Training> {
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
    final trainingProvider = context.watch<EmployeeProvider>();

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: const CustomAppBarProfile(title: "Training and Certificate"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: trainingProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : trainingProvider.traning.isEmpty
                ? const Center(child: Text("No record"))
                : ListView.builder(
                    itemCount: trainingProvider.traning.length,
                    itemBuilder: (context, index) {
                      EmployeeTraining trainingdetails =
                          trainingProvider.traning[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: cardBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ExpansionTile(
                            title: Text(
                              trainingdetails.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            childrenPadding: const EdgeInsets.all(16.0),
                            children: [
                              _buildInfoRow(
                                  "Institue", trainingdetails.institute),
                              _buildInfoRow("Country", trainingdetails.country),
                              _buildInfoRow("Major Subject",
                                  trainingdetails.majorSubject),
                              _buildInfoRow(
                                "From Date",
                                DateFormat('yyyy-MM-dd').format(
                                    DateTime.parse(trainingdetails.fromDate)),
                              ),
                              _buildInfoRow(
                                  "todate",
                                  DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(trainingdetails.toDate))),
                              _buildInfoRow("ParticipationType",
                                  trainingdetails.participationType),
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
