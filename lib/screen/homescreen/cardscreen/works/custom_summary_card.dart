import 'package:flutter/material.dart';

class SummaryCard extends StatefulWidget {
  final String title;
  final String count;
  final Color countColor;
  final double screenWidth;

  const SummaryCard({
    super.key,
    required this.title,
    required this.count,
    required this.countColor,
    required this.screenWidth,
  });

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.screenWidth * 0.4,
      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(height: 4),
          Text(widget.count.toString(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.countColor)),
        ],
      ),
    );
  }
}
