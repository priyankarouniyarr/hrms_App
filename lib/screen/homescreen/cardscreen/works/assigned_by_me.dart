import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/workflow_view.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/custom_summary_card.dart';

class AssignedByMe extends StatefulWidget {
  const AssignedByMe({super.key});

  @override
  State<AssignedByMe> createState() => _AssignedByMeState();
}

class _AssignedByMeState extends State<AssignedByMe> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(), // Smooth scrolling effect
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SummaryCard(
                    title: "Open",
                    count: "0",
                    countColor: Colors.red,
                    screenWidth: screenWidth,
                  ),
                  SummaryCard(
                    title: "Closed",
                    count: "0",
                    countColor: Colors.green,
                    screenWidth: screenWidth,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 16),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "No data available",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ),

              const SizedBox(height: 16),

              // Average Duration for Work Completion
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Average Duration for\n Work Completion",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      "0.0",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primarySwatch[900]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // View Works Button
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WorkflowView()));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    color: primarySwatch[900],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'View Works',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cardBackgroundColor,
                    ),
                    textAlign: TextAlign.center,
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
