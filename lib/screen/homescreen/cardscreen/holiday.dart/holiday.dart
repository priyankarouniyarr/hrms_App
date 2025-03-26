import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/models/holidays/holidays_model.dart';
import 'package:flutter_bs_ad_calendar/flutter_bs_ad_calendar.dart';
import 'package:hrms_app/providers/create_tickets/holidays_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class HolidayScreen extends StatefulWidget {
  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  DateTime? selectedDate;
  List<Map<String, dynamic>> selectedDateHolidays = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HolidayProvider>(context, listen: false).fetchPastHolidays();
      Provider.of<HolidayProvider>(context, listen: false).fetchAllHolidays();
      Provider.of<HolidayProvider>(context, listen: false)
          .fetchUpcomingHolidays();
    });
  }

  @override
  Widget build(BuildContext context) {
    final holidaysProvider = Provider.of<HolidayProvider>(context);

    List<DateTime> holidayDates = holidaysProvider.allHolidayDatePairs
        .map((holiday) => holiday['enDate'] as DateTime)
        .toList();

    return Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: const CustomAppBarProfile(
          title: "My Office",
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Holidays",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: cardBackgroundColor,
                        shadowColor: Colors.grey.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height: 400,
                            child: Transform.scale(
                              scale: 1.1,
                              child: FlutterBSADCalendar(
                                weekColor: Colors.green,
                                calendarType: CalendarType.bs,

                                primaryColor: Colors.blueAccent,
                                holidays: holidayDates,
                                holidayColor: Colors.red,
                                mondayWeek: false,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2048),
                                todayDecoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: Theme.of(context).primaryColorLight,
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  shape: BoxShape.rectangle,
                                ),
                                selectedDayDecoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: Theme.of(context).primaryColorDark,
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  shape: BoxShape.rectangle,
                                ),
                                // onMonthChanged: (date, events) {
                                //   setState(() {
                                //     selectedDate = date;
                                //   });
                                //   print("hello");
                                // },
                                onDateSelected: (date, events) {
                                  setState(() {
                                    selectedDate = date;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])))));
  }
}
