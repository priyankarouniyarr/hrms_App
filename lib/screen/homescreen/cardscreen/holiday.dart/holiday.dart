import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/models/holidays_model.dart';
import 'package:hrms_app/storage/holidays_provider.dart';
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
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHolidayList(context, 'Past Holidays',
                      Provider.of<HolidayProvider>(context).pastHolidays),

                  _buildHolidayList(context, 'Upcoming Holidays',
                      Provider.of<HolidayProvider>(context).upcomingHolidays),

                  // All Holidays List
                  _buildHolidayList(context, 'All Holidays',
                      Provider.of<HolidayProvider>(context).allHolidays),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildHolidayList(
      BuildContext context, String title, List<Holidays> holidays) {
    print("Building Holiday List for $title: ${holidays.length} items");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          holidays.isEmpty
              ? Text('No holidays available')
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: holidays.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(holidays[index].title ?? 'No Title'),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            '${holidays[index].fromDate.toLocal()} to ${holidays[index].toDate.toLocal()}'),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
