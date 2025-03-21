import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/providers/new_tickets_providers/ne_tickets_providers.dart';
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
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<NewTicketProvider>(context, listen: false)
          .fetchTicketCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewTicketProvider>(context);
    File? selectedImage;
    String base64Image = "";
    String? selectedFileName;
    Future<void> chooseImage(type) async {
      var image;
      if (type == "camera") {
        image = await ImagePicker()
            .pickImage(source: ImageSource.camera, imageQuality: 10);
      } else {
        image = await ImagePicker()
            .pickImage(source: ImageSource.gallery, imageQuality: 25);
      }
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
          base64Image = base64Encode(selectedImage!.readAsBytesSync());
          selectedFileName = image.name;
        });
      }
    }

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: const CustomAppBarProfile(title: "Create Ticket"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //categories
                  const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.errorMessage.isNotEmpty
                          ? Center(child: Text(provider.errorMessage))
                          : CustomDropdown(
                              value: _selectedCategoriesType,
                              items: provider.categories
                                  .map((category) => category.text)
                                  .toList(),
                              hintText: 'Select Category',
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategoriesType = value;
                                });
                              },
                            ),
                  SizedBox(height: 10),
                  //ticket Subject
                  const Text(
                    "Ticket Subject",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter Subject',
                      hintStyle: TextStyle(color: primarySwatch[900]),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: primarySwatch, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: primarySwatch, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                      filled: true,
                      fillColor: cardBackgroundColor,
                    ),
                    cursorColor: primarySwatch[900],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //ticket message
                  const Text(
                    "Ticket Message",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Enter a Message',
                      hintStyle: TextStyle(color: primarySwatch[900]),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: primarySwatch, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: primarySwatch, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                      filled: true,
                      fillColor: cardBackgroundColor,
                    ),
                    cursorColor: primarySwatch[900],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Attach Files",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          chooseImage("camera");
                        },
                        child: const Icon(Icons.camera_alt_outlined,
                            color: primarySwatch, size: 30),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          chooseImage("Gallery");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primarySwatch,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Select Files",
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 16, // Text size
                              fontWeight: FontWeight.bold, // Text weight
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  // Show selected image file name
                  if (selectedFileName != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      "Selected File: $selectedFileName",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  const SizedBox(height: 10),

                  //serverity
                  const Text(
                    "Severity",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  //priority
                  const Text(
                    "Ticket Priority",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomDropdown(
                    value: _selectedpriorityType,
                    items: ['Low', 'Medium', 'High'],
                    onChanged: (value) {
                      setState(() {
                        _selectedpriorityType = value;
                      });
                    },
                    hintText: '',
                  ),
                  const SizedBox(height: 10),
                  //assign to
                  const Text(
                    "Assign To",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  CustomDropdown(
                    value: _selectedassigntoType,
                    items:
                        provider.userList.map((users) => users.text).toList(),
                    hintText: '',
                    onChanged: (value) {
                      setState(() {
                        _selectedassigntoType = value;
                      });
                    },
                  ),
                  //button
                  const SizedBox(height: 30),
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
                            child: const Text(
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
                      const SizedBox(width: 10),
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
                            child: const Text(
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
