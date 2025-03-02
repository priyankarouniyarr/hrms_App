import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/models/holidays_model.dart';
import 'package:hrms_app/providers/holidays_provider.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/holiday.dart/hoildays_details_screen.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class HolidayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(
        title: "My Office",
      ),
      body: FutureBuilder(
        future: Future.wait([
          Provider.of<HolidayProvider>(context, listen: false)
              .fetchPastHolidays(),
          Provider.of<HolidayProvider>(context, listen: false)
              .fetchUpcomingHolidays(),
          Provider.of<HolidayProvider>(context, listen: false)
              .fetchAllHolidays(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildHolidayCard(
                      context,
                      'Past Holidays',
                      Provider.of<HolidayProvider>(context).pastHolidays,
                      accentColor),
                  _buildHolidayCard(
                    context,
                    'Upcoming Holidays',
                    Provider.of<HolidayProvider>(context).upcomingHolidays,
                    const Color.fromARGB(255, 5, 239, 126),
                  ),
                  _buildHolidayCard(
                    context,
                    'All Holidays',
                    Provider.of<HolidayProvider>(context).allHolidays,
                    Colors.blueAccent,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  /// Creates a Card for each Holiday Category
  Widget _buildHolidayCard(BuildContext context, String title,
      List<Holidays> holidays, Color color) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HolidayDetailsScreen(title: title, holidays: holidays),
        ),
      ),
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: cardBackgroundColor,
                ),
              ),
              CircleAvatar(
                backgroundColor: cardBackgroundColor,
                child: Text(
                  holidays.length.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
