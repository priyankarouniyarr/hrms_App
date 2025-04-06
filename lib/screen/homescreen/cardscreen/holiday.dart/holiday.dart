import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:flutter_bs_ad_calendar/flutter_bs_ad_calendar.dart';
import 'package:hrms_app/providers/holidays_provider/holidays_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen categories/customprofile_appbar.dart';

class HolidayScreen extends StatefulWidget {
  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  DateTime? selectedDate;
  List<Map<String, dynamic>> selectedDateHolidays = [];
  List<Map<String, dynamic>> selectedMonthHolidays = [];

  DateTime? currentDisplayedMonth;
  @override
  @override
  void initState() {
    super.initState();
    // Initialize with current month

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final holidaysProvider =
          Provider.of<HolidayProvider>(context, listen: false);
      await holidaysProvider.fetchPastHolidays();
      await holidaysProvider.fetchUpcomingHolidays();
//for month
      setState(() {});
      setState(() {
        selectedDate = DateTime.now().toNepaliDateTime();

        print(selectedDate);

        selectedDateHolidays =
            holidaysProvider.allHolidayDatePairs.where((holiday) {
          DateTime holidayDate = holiday['enDate'] as DateTime;
          return holidayDate.year == selectedDate!.year &&
              holidayDate.month == selectedDate!.month &&
              holidayDate.day == selectedDate!.day;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final holidaysProvider = Provider.of<HolidayProvider>(context);
    final theme = Theme.of(context);

    List<DateTime> holidayDates = holidaysProvider.allHolidayDatePairs
        .map((holiday) => holiday['enDate'] as DateTime)
        .toList();

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: const CustomAppBarProfile(
        title: "Office Holidays",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // Calendar Card
              _buildCalendarCard(holidayDates, theme),
              const SizedBox(height: 24),

              // Holiday List Section
              _buildHolidayListSection(holidaysProvider, theme),

              // Add some extra padding at the bottom
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Text(
      "Holiday Calendar",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildCalendarCard(List<DateTime> holidayDates, ThemeData theme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 400,
          child: FlutterBSADCalendar(
            weekColor: Colors.green,
            calendarType: CalendarType.bs,
            primaryColor: theme.primaryColor,
            holidays: holidayDates,
            holidayColor: accentColor,
            mondayWeek: false,
            initialDate: DateTime.now(),
            firstDate: DateTime(2015),
            lastDate: DateTime(2040),
            todayDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.primaryColor.withOpacity(0.2),
              border: Border.all(
                color: theme.primaryColor,
                width: 1.5,
              ),
            ),
            selectedDayDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            onDateSelected: (date, events) {
              setState(() {
                selectedDate = date.toDateTime();

                selectedDateHolidays =
                    Provider.of<HolidayProvider>(context, listen: false)
                        .allHolidayDatePairs
                        .where((holiday) {
                  DateTime bsHolidayDate = holiday['enDate'];
                  NepaliDateTime holidayDate = bsHolidayDate.toNepaliDateTime();
                  return holidayDate.year == date.year &&
                      holidayDate.month == date.month &&
                      holidayDate.day == date.day;
                }).toList();
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHolidayListSection(
      HolidayProvider holidaysProvider, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedDate != null)
          Text(
            selectedDateHolidays.isNotEmpty
                ? " ${NepaliDateFormat('d MMMM y').format(selectedDate!.toNepaliDateTime())}"
                : "",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        const SizedBox(height: 12),
        if (selectedDate != null && selectedDateHolidays.isNotEmpty)
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: selectedDateHolidays.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final holiday = selectedDateHolidays[index];
              return _buildHolidayCard(holiday);
            },
          ),
      ],
    );
  }

  Widget _buildHolidayCard(Map<String, dynamic> holiday) {
    final nepaliDate = (holiday['enDate'] as DateTime).toNepaliDateTime();

    return Card(
      color: Colors.red,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    holiday['description'] ?? 'Holiday',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: cardBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: cardBackgroundColor,
                    ),
                  ),
                  child: Text(
                    "Holiday",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildDateChip(
                  "AD",
                  DateFormat('MMM d, yyyy').format(holiday['enDate']),
                ),
                const SizedBox(width: 8),
                _buildDateChip(
                  "BS",
                  NepaliDateFormat('y MMMM d').format(nepaliDate),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateChip(String label, String date) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[200]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              date,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: primarySwatch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
