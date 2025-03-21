import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';
// Remove this duplicate block:

class WorkflowView extends StatefulWidget {
  const WorkflowView({super.key});

  @override
  State<WorkflowView> createState() => _WorkflowViewState();
}

class _WorkflowViewState extends State<WorkflowView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: CustomAppBarProfile(title: " All Workflows"),
        body: SafeArea(
          child: Column(
            children: [],
          ),
        ));
  }
}
