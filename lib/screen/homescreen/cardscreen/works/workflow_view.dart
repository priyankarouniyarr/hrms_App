import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/works.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen categories/customprofile_appbar.dart';

class WorkflowView extends StatefulWidget {
  @override
  State<WorkflowView> createState() => _WorkflowViewState();
}

class _WorkflowViewState extends State<WorkflowView> {
  // Initial filter values
  String _selectedFilter1 = 'Open';
  String _selectedFilter2 = 'Low';
  String _selectedFilter3 = 'Low';
  String _selectedFilter4 = 'Oldest';
  int _selectedIndex = 0; // For managing selected tab index
  // Dropdown options
  final List<String> _filterOptions1 = ['Open', 'Closed', 'All'];
  final List<String> _filterOptions2 = ['Low', 'Medium', 'High'];
  final List<String> _filterOptions3 = ['Low', 'Medium', 'High'];
  final List<String> _filterOptions4 = ['Oldest', 'Newest'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "All WorkFlows"),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // First Dropdown
                  Expanded(
                    child: DropdownButtonFormField2<String>(
                      iconStyleData: IconStyleData(
                          iconEnabledColor: primarySwatch,
                          iconDisabledColor: Colors.grey),
                      value: _selectedFilter1,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: primarySwatch, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: primarySwatch, width: 3),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: _filterOptions1
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter1 = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Second Dropdown (DropdownButtonFormField2)
                  Expanded(
                    child: DropdownButtonFormField2<String>(
                      iconStyleData: IconStyleData(
                          iconEnabledColor: primarySwatch,
                          iconDisabledColor: Colors.grey),
                      value: _selectedFilter2,
                      isExpanded: true,
                      hint: Text(
                        'Severity', // Shown when nothing is selected
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: primarySwatch, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: primarySwatch, width: 3),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: _filterOptions2
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter2 = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Second row of filters with DropdownButtonFormField2
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Third Dropdown (Priority)
                  Expanded(
                    child: DropdownButtonFormField2<String>(
                      value: _selectedFilter3,
                      iconStyleData: IconStyleData(
                          iconEnabledColor: primarySwatch,
                          iconDisabledColor: Colors.grey),
                      isExpanded: true,
                      hint: Text(
                        'Priority',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: primarySwatch, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: primarySwatch, width: 3),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: _filterOptions3
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter3 = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Fourth Dropdown (Oldest/Newest)
                  Expanded(
                    child: DropdownButtonFormField2<String>(
                      iconStyleData: IconStyleData(
                          iconEnabledColor: primarySwatch,
                          iconDisabledColor: Colors.grey),
                      value: _selectedFilter4,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: primarySwatch, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: primarySwatch, width: 3),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: _filterOptions4
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter4 = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                color: primarySwatch,
                thickness: 1.5,
              ),
            ),
            SizedBox(height: 15),
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
                color: primaryTextColor,
                selectedColor: backgroundColor,
                fillColor: primarySwatch[900], // Selected background
                borderRadius: BorderRadius.circular(10),
                borderColor: lightColor,
                selectedBorderColor: primarySwatch[900],
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60),
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
          ],
        ),
      ),
    );
  }
}
