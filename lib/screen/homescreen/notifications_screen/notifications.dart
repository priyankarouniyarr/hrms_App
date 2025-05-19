import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class Notifications extends StatelessWidget {
  final String? title;
  final String? body;
  const Notifications({super.key, this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: CustomAppBarProfile(
          title: 'Notifications',
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Text(
                title ?? '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                body ?? '',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              )
            ])));
  }
}
