import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';

class ShiftScreen extends StatefulWidget {
  @override
  _ShiftScreenState createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(context, listen: false)
          .fetchEmployeeDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmployeeProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentshifts = provider.currentShift;

    final shiftData = [
      {
        'shift': currentshifts.primaryShiftName,
        'shifttime': currentshifts.primaryShiftStart,
        'shiftend': currentshifts.primaryShiftEnd,
      },
      if (currentshifts.hasBreak == true)
        {
          'shift': 'Break',
          'shifttime': currentshifts.breakStartTime,
          'shiftend': currentshifts.breakEndTime,
        },
      if (currentshifts.hasMultiShift == true)
        {
          'shift': 'Extended Shift',
          'shifttime': currentshifts.extendedShiftStart,
          'shiftend': currentshifts.extendedShiftEnd,
        },
    ];

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 4,
          child: PageView.builder(
            controller: _pageController,
            itemCount: shiftData.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final currentShift = shiftData[index];
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: ShiftCard(
                  dateNp: currentshifts.currentDateNp,
                  shift: currentShift['shift']!,
                  shifttime: currentShift['shifttime']!,
                  shiftend: currentShift['shiftend']!,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            shiftData.length,
            (index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                child: Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
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
  final String shift;
  final String? dateNp;
  final String? shifttime;
  final String? shiftend;

  const ShiftCard({
    required this.shift,
    this.dateNp,
    this.shifttime,
    this.shiftend,
  });

  @override
  Widget build(BuildContext context) {
    DateTime shiftStartTime = DateTime.parse(shifttime!);
    DateTime shiftEndTime = DateTime.parse(shiftend!);

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
              Text(dateNp!,
                  style: TextStyle(
                      color: cardBackgroundColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                    color: cardBackgroundColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(shift,
                    style: TextStyle(
                        color: primarySwatch[900],
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: primarySwatch[900],
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeColumn("Shift Start", shiftStartTime),
                Container(width: 3, height: 40, color: cardBackgroundColor),
                _buildTimeColumn("Shift End", shiftEndTime),
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
            style: const TextStyle(
                color: cardBackgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        Text("${time.hour}:${time.minute.toString().padLeft(2, '0')}",
            style: const TextStyle(
                color: cardBackgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
