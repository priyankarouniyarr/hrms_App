import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/models/attendance_details_models.dart';
import 'package:hrms_app/providers/attendance_providers/attendance_history_provider.dart';

class ShiftScreen extends StatefulWidget {
  @override
  _ShiftScreenState createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize provider when the screen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceDetailsProvider>(context, listen: false)
          .initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceDetailsProvider>(context);

    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final attendanceDetails = provider.attendanceDetails;

    if (attendanceDetails == null ||
        attendanceDetails.attendanceDetails.isEmpty) {
      return Center(child: Text("No shift data available"));
    }

    final todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

    final todayShifts = attendanceDetails.attendanceDetails.where((shift) {
      final shiftDate = DateFormat("yyyy-MM-dd").format(shift.attendanceDate);

      return shiftDate == todayDate;
    }).toList();

    if (todayShifts.isEmpty) {
      return Center(child: Text("No shifts for today"));
    }

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 5,
          child: PageView.builder(
            controller: _pageController,
            itemCount: todayShifts.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final shift = todayShifts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ShiftCard(shift: shift),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            todayShifts.length,
            (index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                child: Container(
                  width: 10,
                  height: 10,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? cardBackgroundColor
                        : Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ShiftCard extends StatelessWidget {
  final AttendanceDetail shift;

  const ShiftCard({required this.shift});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: shiftcard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(NepaliDateFormat("yyyy-MM-dd").format(NepaliDateTime.now()),
                  style: TextStyle(
                      color: cardBackgroundColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: cardBackgroundColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(shift.shiftTitle,
                    style: TextStyle(
                        color: primarySwatch[900],
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: primarySwatch[900],
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeColumn("Shift Start", shift.shiftStartTime),
                Container(width: 3, height: 40, color: cardBackgroundColor),
                _buildTimeColumn("Shift End", shift.shiftEndTime),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(String label, DateTime time) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                color: cardBackgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        SizedBox(height: 5),
        Text("${time.hour}:${time.minute.toString().padLeft(2, '0')}",
            //ensures that minutes are always displayed with two digits
            style: TextStyle(
                color: cardBackgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
