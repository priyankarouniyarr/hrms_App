import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/models/notices_models.dart';
import 'package:hrms_app/providers/notices_provider.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/notices/noticesdetails_screen.dart';
import '../../../profile/subcategories/appbar_profilescreen categories/customprofile_appbar.dart';

class NoticesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch notices data from the NoticesProvider
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "All Notices"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: Provider.of<NoticesProvider>(context, listen: false)
              .fetchNotice(),
          builder: (context, snapshot) {
            // Check if data is being loaded
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // Check for errors
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Get the list of notices from the provider
            final notices = Provider.of<NoticesProvider>(context).notices;

            // Show a message if no notices are found
            if (notices.isEmpty) {
              return Center(child: Text('No notices available.'));
            }

            // Display the notices dynamically from the provider
            return ListView.builder(
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigate to the NoticeDetailScreen with the selected notice
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NoticeDetailScreen(notice: notice),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // Format the date as needed
                            notice.publishedTime != null
                                ? notice.publishedTime!.toString()
                                : "No date available",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[900],
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                notice.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                // Display a placeholder for time or published time
                                notice.publishedTime != null
                                    ? notice.publishedTime!
                                        .toLocal()
                                        .toString()
                                        .split(' ')[1]
                                    : 'N/A',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            notice
                                .excerpt, // Display the excerpt (short description)
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
