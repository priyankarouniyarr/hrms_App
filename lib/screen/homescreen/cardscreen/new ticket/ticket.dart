import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/widget/dropdown_custom.dart';
import 'package:hrms_app/providers/create_tickets/ne_tickets_providers.dart';
import 'package:hrms_app/providers/create_tickets/new_tickets_provider.dart';
import 'package:hrms_app/models/createtickets/new_tickets_creation_model.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class CreateTicketScreen extends StatefulWidget {
  @override
  _CreateTicketScreenState createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  int? _selectedCategoriesType;
  String? _selectedpriorityType;
  int? _selectedassigntoType;
  String? _selectedServerityType;
  File? selectedImage;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NewTicketProvider>(context, listen: false)
          .fetchTicketCategories();
    });
  }

  Future<void> chooseImage(String type) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: type == "camera" ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 25,
    );
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoriesType == null ||
          _selectedpriorityType == null ||
          _selectedassigntoType == null ||
          _selectedServerityType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please fill all fields',
              style: TextStyle(color: accentColor, fontSize: 20),
            ),
            backgroundColor: cardBackgroundColor,
          ),
        );
        return;
      }

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Create the ticket request
        final ticketRequest = TicketCreationRequest(
          ticketCategoryId: _selectedCategoriesType!,
          priority: _selectedpriorityType!,
          assignToEmployeeId: _selectedassigntoType!,
          severity: _selectedServerityType!,
          title: _subjectController.text,
          description: _messageController.text,
          attachmentPaths: selectedImage != null ? [selectedImage!.path] : [],
        );

        final ticketProvider =
            Provider.of<TicketProvider>(context, listen: false);
        final success = await ticketProvider.createTicket(ticketRequest);

        Navigator.of(context).pop();

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Ticket created successfully!',
                style: TextStyle(color: Colors.green, fontSize: 18),
              ),
              backgroundColor: cardBackgroundColor,
            ),
          );
          _resetForm();
        } else {
          print(ticketProvider.errorMessage);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ticketProvider.errorMessage,
                style: const TextStyle(color: accentColor),
                textAlign: TextAlign.center,
              ),
              backgroundColor: cardBackgroundColor,
            ),
          );
        }
      } catch (e) {
        // Hide loading indicator
        Navigator.of(context).pop();
        print(e);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error creating ticket: $e',
              style: const TextStyle(color: Colors.red),
            ),
            backgroundColor: cardBackgroundColor,
          ),
        );
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedCategoriesType = null;
      _selectedpriorityType = null;
      _selectedassigntoType = null;
      _selectedServerityType = null;
      selectedImage = null;
      _messageController.clear();
      _subjectController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewTicketProvider>(context);

    List<Map<String, dynamic>> assignTo = provider.userList
        .map((assignTo) =>
            {'label': assignTo.text, 'value': int.parse(assignTo.value)})
        .toList();
    List<Map<String, dynamic>> categories = provider.categories
        .map((assignTo) =>
            {'label': assignTo.text, 'value': int.parse(assignTo.value)})
        .toList();

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: const CustomAppBarProfile(title: "Create Ticket"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
                  CustomDropdown2(
                    value: _selectedCategoriesType,
                    items: categories,
                    hintText: 'Select Category',
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoriesType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
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
                    controller: _subjectController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Subject is required';
                      }
                      return null;
                    },
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
                  const SizedBox(height: 10),
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
                    controller: _messageController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Message is required';
                      }
                      return null;
                    },
                    maxLines: 2,
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
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  if (selectedImage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      selectedImage!.path.split('/').last,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: primarySwatch),
                      textAlign: TextAlign.justify,
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
                  CustomDropdown2(
                    value: _selectedassigntoType,
                    items: assignTo,
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
                            onPressed: _submitForm,
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
                              backgroundColor: primarySwatch[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _resetForm,
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
