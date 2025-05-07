import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/models/notices_models/notices_models.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class NoticeDetailScreen extends StatefulWidget {
  final Notices notice;

  const NoticeDetailScreen({required this.notice});

  @override
  State<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarProfile(title: "Notice Details"),
      backgroundColor: cardBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.notice.title.trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 0.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 8,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        categoryValues.reverse[widget.notice.category] ??
                            'Unknown',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                if (widget.notice.publishedTime != null)
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Align date & time
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18, color: Colors.blue), // Date Icon
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('yyyy-MM-dd').format(
                                widget.notice.publishedTime!), // Only date
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 18, color: Colors.blue), // Time Icon
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('HH:mm:ss').format(
                                widget.notice.publishedTime!), // Only time
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 15),
                Divider(color: Colors.grey[300], thickness: 1),
                const SizedBox(height: 15),
                Text(
                  widget.notice.content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
