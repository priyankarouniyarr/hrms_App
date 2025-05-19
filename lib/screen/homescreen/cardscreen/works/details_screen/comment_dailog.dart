import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/models/works_models/comments_models.dart';
import 'package:hrms_app/providers/works_Summary_provider/ticket_workflow.dart';

class CommentDialog extends StatefulWidget {
  final int ticketId;

  const CommentDialog({Key? key, required this.ticketId}) : super(key: key);

  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final TextEditingController _commentController = TextEditingController();
  File? selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      if (_commentController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please fill comments fields',
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
        final commentrequest = CommentsModels(
          ticketId: widget.ticketId,
          comment: _commentController.text,
          attachmentPaths: selectedImage != null ? [selectedImage!.path] : [],
        );

        final commentProvider =
            Provider.of<TicketWorkFlowProvider>(context, listen: false);
        final success = await commentProvider.commentTicket(commentrequest);

        Navigator.of(context).pop(); // Close loading dialog

        if (success) {
          await commentProvider.fetchMyTicketDetaisById(
              ticket: widget.ticketId);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Commented successfully!',
                style: TextStyle(color: Colors.green, fontSize: 18),
              ),
              backgroundColor: cardBackgroundColor,
            ),
          );

          Navigator.of(context).pop(); // Close comment dialog
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              commentProvider.errormessage!,
              style: const TextStyle(color: accentColor),
              textAlign: TextAlign.justify,
            ),
            backgroundColor: cardBackgroundColor,
          ));
        }
      } catch (e) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error comment: $e',
              style: const TextStyle(color: Colors.red),
            ),
            backgroundColor: cardBackgroundColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: const Text("Add Comment"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Write your comment here...",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    minLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.camera_alt, color: primarySwatch),
                        onPressed: () async {
                          await chooseImage("camera");
                        },
                        tooltip: "Take a Photo",
                      ),
                      IconButton(
                        icon: const Icon(Icons.photo_library,
                            color: primarySwatch),
                        onPressed: () async {
                          await chooseImage("gallery");
                        },
                        tooltip: "Choose from Gallery",
                      ),
                    ],
                  ),
                  if (selectedImage != null) ...[
                    Text(
                      selectedImage!.path.split('/').last,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: primarySwatch),
                      textAlign: TextAlign.justify,
                    ),
                  ]
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                onPressed: () {
                  _commentController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primarySwatch),
                onPressed: _submitForm,
                child: const Text(
                  "Post",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
