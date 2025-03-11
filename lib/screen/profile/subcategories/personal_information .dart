import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class PersonalInformationScreen extends StatefulWidget {
  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  @override
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
    final informationProvider = Provider.of<EmployeeProvider>(context);

    // Show a loading indicator if data is still being fetched
    if (informationProvider.isLoading) {
      return Scaffold(
        appBar: CustomAppBarProfile(title: "Personal Information"),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "Personal Information"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRow(
                  title: "Full Name (English)",
                  value: informationProvider.fullname),
              InfoRow(
                  title: "Full Name (Nepali)",
                  value: informationProvider.devnagariName),
              InfoRow(
                  title: "Email Address (Personal)",
                  value: informationProvider.email),
              InfoRow(
                  title: "Phone Number (Personal)",
                  value: informationProvider.phone),
              InfoRow(title: "Gender", value: informationProvider.gender),
              InfoRow(
                  title: "Date of Birth",
                  value: informationProvider.dateofBirth),
              InfoRow(
                  title: "Permanent Address",
                  value:
                      '${informationProvider.permanentAddress.addressLine1}, ${informationProvider.permanentAddress.ward}, ${informationProvider.permanentAddress.municipalName}'),
              InfoRow(
                  title: "Temporary Address",
                  value:
                      '${informationProvider.temporaryAddress.addressLine1}, ${informationProvider.temporaryAddress.ward}, ${informationProvider.temporaryAddress.municipalName}'),
              InfoRow(
                  title: "Marital Status",
                  value: informationProvider.maritalStatus),
              InfoRow(
                  title: "Blood Group", value: informationProvider.bloodGroup),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Divider(), // Adds a simple separator
        ],
      ),
    );
  }
}
