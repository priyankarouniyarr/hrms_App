import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/notices_provider/notices_provider.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/notices/noticesdetails_screen.dart';
import '../../../profile/subcategories/appbar_profilescreen categories/customprofile_appbar.dart';

class NoticesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: const CustomAppBarProfile(title: "All Notices"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: Provider.of<NoticesProvider>(context, listen: false)
              .fetchNotice(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final notices = Provider.of<NoticesProvider>(context).notices;
            if (notices.isEmpty) {
              return const Center(
                child: Text(
                  'No notices available.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              );
            }

            // Reverse the notices list so the latest one appears first
            final reversedNotices = notices.reversed.toList();

            return ListView.builder(
              itemCount: reversedNotices.length,
              itemBuilder: (context, index) {
                final notice = reversedNotices[index];
                return Card(
                  elevation: 8, // Added higher elevation for depth
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NoticeDetailScreen(notice: notice),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date & Time Row with Icons
                          if (notice.publishedTime != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 20, color: Colors.blue[600]),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(notice.publishedTime!),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        size: 20, color: Colors.blue[600]),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('HH:mm:ss')
                                          .format(notice.publishedTime!),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          const SizedBox(height: 12),

                          // Notice Title
                          Text(
                            notice.title.length > 100
                                ? '${notice.title.substring(0, notice.title.length ~/ 3)}....'
                                : notice.title,
                            style: const TextStyle(
                              fontSize: 18, // Larger font size
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 0.4,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 12),

                          // Notice Content Preview
                          Text(
                            notice.content.length > 100
                                ? '${notice.content.substring(0, notice.content.length ~/ 15)}...' // Show part of content
                                : notice.content,
                            style: TextStyle(
                              fontSize: 16, // Slightly larger font size
                              color: Colors.grey[600],
                              height: 1.3,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 16),

                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Read More →",
                              style: TextStyle(
                                fontSize: 16, // Larger size for better emphasis
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
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
