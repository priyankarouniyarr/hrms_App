import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/models/holidays_model.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class HolidayDetailsScreen extends StatelessWidget {
  final String title;
  final List<Holidays> holidays;

  const HolidayDetailsScreen({required this.title, required this.holidays});

  @override
  Widget build(BuildContext context) {
    // Sorting holidays in decreasing order based on A.D. date
    List<Holidays> sortedHolidays = List.from(holidays)
      ..sort((a, b) => b.toDate.compareTo(a.toDate));

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: title),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: sortedHolidays.isEmpty
              ? const Center(
                  child: Text(
                    'No holidays available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                )
              : ResponsiveHolidayTable(holidays: sortedHolidays),
        ),
      ),
    );
  }
}

/// Responsive Table & List View
class ResponsiveHolidayTable extends StatelessWidget {
  final List<Holidays> holidays;

  const ResponsiveHolidayTable({required this.holidays});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isLargeScreen = constraints.maxWidth > 600;

        return isLargeScreen
            ? HolidayTable(holidays: holidays) // Table view for large screens
            : HolidayCardList(
                holidays: holidays); // Card list for small screens
      },
    );
  }
}

/// Table View for Large Screens (Web & Tablets)**
class HolidayTable extends StatelessWidget {
  final List<Holidays> holidays;

  const HolidayTable({required this.holidays});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DataTable(
          columnSpacing: 12,
          border: TableBorder.all(color: Colors.grey.shade300, width: 1),
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.blue.shade100),
          columns: _buildTableColumns(),
          rows: holidays.map((holiday) => HolidayRow(holiday)).toList(),
        ),
      ),
    );
  }

  List<DataColumn> _buildTableColumns() {
    return [
      const DataColumn(label: TableHeader(text: 'SN')),
      const DataColumn(label: TableHeader(text: 'Date (B.S)')),
      const DataColumn(label: TableHeader(text: 'Date (A.D)')),
      const DataColumn(label: TableHeader(text: 'Title')),
      const DataColumn(label: TableHeader(text: 'Day')),
    ];
  }
}

/// Card-based List View for Small Screens (Mobile)
class HolidayCardList extends StatelessWidget {
  final List<Holidays> holidays;

  const HolidayCardList({required this.holidays});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: holidays.length,
      separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
      itemBuilder: (context, index) {
        final holiday = holidays[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.blue.shade600],
                  ),
                ),
                child: Center(
                  child: Text(
                    holiday.title ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Colors.blueAccent),
                        const SizedBox(width: 6),
                        Text(
                          "Date (B.S): ${DateFormatter.formatNepaliDate(holiday.toDateNp)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.date_range, color: Colors.green),
                        const SizedBox(width: 6),
                        Text(
                          "Date (A.D): ${DateFormat('yyyy-MM-dd').format(holiday.toDate)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.event, color: Colors.orange),
                        const SizedBox(width: 6),
                        Text(
                          "Day: ${DateFormatter.getDayOfWeek(holiday.toDate)}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Row Representation for Table**
class HolidayRow extends DataRow {
  final Holidays holiday;

  HolidayRow(this.holiday)
      : super(
          cells: [
            DataCell(Text(holiday.id.toString())),
            DataCell(Text(DateFormatter.formatNepaliDate(holiday.toDateNp))),
            DataCell(Text(DateFormat('yyyy-MM-dd').format(holiday.toDate))),
            DataCell(Text(holiday.title ?? 'No Title')),
            DataCell(Text(DateFormatter.getDayOfWeek(holiday.toDate))),
          ],
        );
}

/// table Header Widget**
class TableHeader extends StatelessWidget {
  final String text;

  const TableHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
      textAlign: TextAlign.center,
    );
  }
}

/// Utility Class for Date Formatting**
class DateFormatter {
  static String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static String formatNepaliDate(String nepaliDate) {
    try {
      DateTime date = DateFormat('yyyy/MM/dd').parse(nepaliDate);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return nepaliDate;
    }
  }
}
