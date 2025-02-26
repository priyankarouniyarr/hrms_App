import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class EmployementContracts extends StatelessWidget {
  const EmployementContracts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: CustomAppBarProfile(title: "Contracts"),
        body: const Padding(
            padding: EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "",
                  style: TextStyle(fontSize: 16),
                ),
              )
            ])));
  }
}
