import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class Workshiftinformation extends StatelessWidget {
  Workshiftinformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: CustomAppBarProfile(title: "Work and Shift Information"),
        body: const Padding(
            padding: EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Shift Information",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Work Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ])));
  }
}
