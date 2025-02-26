import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';

class ShiftScreen extends StatefulWidget {
  @override
  _ShiftScreenState createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentIndex = 0; // Track current index

  final List<Shift> shifts = [
    Shift(
        date: "2081/11/04",
        shiftLabel: "Morning Shift",
        start: "10:00",
        end: "16:00"),
    Shift(
        date: "2081/11/05", shiftLabel: "Break", start: "13:00", end: "13:15"),
    Shift(
        date: "2081/11/05",
        shiftLabel: "Extended Shift",
        start: "16:00",
        end: "19:00"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 5,
          child: PageView.builder(
            controller: _pageController,
            itemCount: shifts.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ShiftCard(shift: shifts[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(shifts.length, (index) {
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
          }),
        ),
      ],
    );
  }
}

//layout of card
class Shift {
  final String date;
  final String shiftLabel;
  final String start;
  final String end;

  Shift(
      {required this.date,
      required this.shiftLabel,
      required this.start,
      required this.end});
}

class ShiftCard extends StatelessWidget {
  final Shift shift;

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
              Text(shift.date,
                  style: TextStyle(
                      color: cardBackgroundColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                    color: cardBackgroundColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(shift.shiftLabel,
                    style: TextStyle(
                        color: primarySwatch[900],
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: primarySwatch[900],
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeColumn("Shift Start", shift.start),
                Container(width: 3, height: 40, color: cardBackgroundColor),
                _buildTimeColumn(" Shift End", shift.end),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(String label, String time) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                color: cardBackgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        SizedBox(height: 5),
        Text(time,
            style: TextStyle(
                color: cardBackgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
