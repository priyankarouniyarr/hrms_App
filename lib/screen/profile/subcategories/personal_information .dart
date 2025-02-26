import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class PersonalInformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "Personal Information"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRow(title: "Full Name (English)", value: "Priyanka Rouniyar"),
              InfoRow(title: "Full Name (Nepali)", value: "null"),
              InfoRow(
                  title: "Email Address (Personal)",
                  value: "priyanka@mail.com"),
              InfoRow(title: "Phone Number (Personal)", value: "null"),
              InfoRow(title: "Gender", value: "Female"),
              InfoRow(title: "Date of Birth", value: "0001-01-01"),
              InfoRow(
                  title: "Permanent Address", value: "null, null, null, null"),
              InfoRow(
                  title: "Temporary Address", value: "null, null, null, null"),
              InfoRow(title: "Marital Status", value: "N/A"),
              InfoRow(title: "Blood Group", value: "N/A"),
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
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Divider(), // Adds a simple separator
        ],
      ),
    );
  }
}
