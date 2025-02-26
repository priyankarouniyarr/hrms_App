import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/assigned_by_me.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/myticketsumarry.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  int _selectedIndex = 0; // For managing selected tab index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: const CustomAppBarProfile(title: "Current Month Work Summary"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Segmented Tab Control using ToggleButtons
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: lightColor),
              ),
              child: ToggleButtons(
                isSelected: [_selectedIndex == 0, _selectedIndex == 1],
                onPressed: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                color: primaryTextColor, // Unselected text
                selectedColor: backgroundColor, // Selected text
                fillColor: primarySwatch[900], // Selected background
                borderRadius: BorderRadius.circular(10),
                borderColor: lightColor,
                selectedBorderColor: primarySwatch[900],
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text('My Ticket', style: TextStyle(fontSize: 18)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child:
                        Text('Assigned By Me', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tab content
            Expanded(
              child: _selectedIndex == 0
                  ? const Myticketsumarry()
                  : const AssignedByMe(),
            ),
          ],
        ),
      ),
    );
  }
}
