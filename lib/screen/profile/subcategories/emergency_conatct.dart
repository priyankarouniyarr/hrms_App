import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: CustomAppBarProfile(title: "Emergency Contact"),
        body: const Padding(
            padding: EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "No any emergency contact found",
                  style: TextStyle(fontSize: 16),
                ),
              )
            ])));
  }
}
