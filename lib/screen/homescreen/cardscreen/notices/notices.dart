import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import '../../../profile/subcategories/appbar_profilescreen categories/customprofile_appbar.dart';

class NoticesScreen extends StatelessWidget {
  final List<Map<String, String>> notices = [
    {
      'date': "2081-12-28",
      'title': 'Notice 1',
      'body': 'Testing process is going on ',
      'time': '10:00 AM'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "All Notices"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notices.length,
          itemBuilder: (context, index) {
            final notice = notices[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notice['date']!,
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
                          notice['title']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          notice['time']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[900],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      notice['body']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
