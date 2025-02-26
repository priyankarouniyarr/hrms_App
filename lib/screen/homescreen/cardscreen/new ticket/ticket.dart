import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class CreateTicketScreen extends StatefulWidget {
  @override
  _CreateTicketScreenState createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  String? _selectedCategoriesType;
  String? _selectedpriorityType;
  String? _selectedassigntoType;
  String? _selectedServerityType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "Create Ticket"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //categories
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomDropdown(
                    value: _selectedCategoriesType,
                    items: ['IT Support', 'Biomedical'],
                    hintText: 'Select',
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoriesType = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  //ticket Subject
                  Text(
                    "Ticket Subject",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter Subject',
                      hintStyle: TextStyle(color: primarySwatch[900]),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primarySwatch, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primarySwatch, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                      filled: true,
                      fillColor: cardBackgroundColor,
                    ),
                    cursorColor: primarySwatch[900],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //ticket message
                  Text(
                    "Ticket Message",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Enter a Message',
                      hintStyle: TextStyle(color: primarySwatch[900]),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primarySwatch, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primarySwatch, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                      filled: true,
                      fillColor: cardBackgroundColor,
                    ),
                    cursorColor: primarySwatch[900],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Attach Files",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),

                  //serverity
                  Text(
                    "Severity",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomDropdown(
                    value: _selectedServerityType,
                    items: ['Low', 'Medium', 'High'],
                    onChanged: (value) {
                      setState(() {
                        _selectedServerityType = value;
                      });
                    },
                    hintText: '',
                  ),
                  SizedBox(height: 10),
                  //priority
                  Text(
                    "Ticket Priority",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomDropdown(
                    value: _selectedpriorityType,
                    items: [''],
                    onChanged: (value) {
                      setState(() {
                        _selectedpriorityType = value;
                      });
                    },
                    hintText: '',
                  ),
                  SizedBox(height: 10),
                  //assign to
                  Text(
                    "Assign To",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomDropdown(
                    value: _selectedassigntoType,
                    items: [''],
                    onChanged: (value) {
                      setState(() {
                        _selectedassigntoType = value;
                      });
                    },
                    hintText: '',
                  ),
                  //button
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primarySwatch[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              // Handle the login action
                            },
                            child: Text(
                              "Create ",
                              style: TextStyle(
                                fontSize: 16,
                                color: cardBackgroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  primarySwatch[900], // Reset button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 16,
                                color: cardBackgroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
