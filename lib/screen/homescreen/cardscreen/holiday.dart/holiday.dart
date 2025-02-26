import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class HolidayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(
        title: "My Office",
      ),
      body: Center(
          child: Container(
        child: Text(""),
      )),
    );
  }
}
