import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/models/profiles.models.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<EmployeeProvider>(context, listen: false)
        .fetchEmployeeDetails());
  }

  @override
  Widget build(BuildContext context) {
    final documentsProvider = context.watch<EmployeeProvider>();

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: const CustomAppBarProfile(title: "Documents"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: documentsProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : documentsProvider.documents.isEmpty
                  ? const Center(child: Text(""))
                  : ListView.builder(
                      itemCount: documentsProvider.documents.length,
                      itemBuilder: (context, index) {
                        EmployeeDocument document =
                            documentsProvider.documents[index];
                        return Card(
                          color: cardBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.file_copy,
                                  color: primarySwatch,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      document.documentNumber,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 8),
                                    Text("/"),
                                    const SizedBox(width: 8),
                                    Text(
                                      document.employeeName,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    _showImageDialog(
                                        context, document.attachmentPath!);
                                  },
                                  child: Icon(
                                    Icons.download,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }

  // Method to show the image dialog
  void _showImageDialog(BuildContext context, String attachmentPath) {
    String imageUrl =
        'http://45.117.153.90:5001/uploads/employeedocuments/$attachmentPath'; // Full image URL

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Attachment Documents'),
          content: SizedBox(
            height: 300,
            width: 300,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                }
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return Center(child: Icon(Icons.error, color: Colors.red));
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
