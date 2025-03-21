import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/workflow_view.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/custom_summary_card.dart';
import 'package:hrms_app/providers/works_Summary_provider/my_ticket_get_summary_provider.dart';

class Myticketsumarry extends StatefulWidget {
  const Myticketsumarry({super.key});

  @override
  State<Myticketsumarry> createState() => _MyticketsumarryState();
}

class _MyticketsumarryState extends State<Myticketsumarry> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MyTicketGetSummaryProvider>(context, listen: false)
          .fetchMyTicket();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final provider = Provider.of<MyTicketGetSummaryProvider>(context);

    //myticket severity type

    List<PieChartSectionData> pieChartServityType() {
      final low = provider.myTicketSummary!.severityLow;
      final medium = provider.myTicketSummary!.severityMedium;
      final high = provider.myTicketSummary!.severityHigh;
      final total = low + medium + high;

      // To avoid division by zero
      String getPercentage(int value) {
        if (total == 0) return '0%';
        double percent = (value / total) * 100;
        return '${percent.toStringAsFixed(0)}%';
      }

      final List<int> values = [low, medium, high];
      final List<Color> colors = [primarySwatch, Colors.orange, Colors.red];
      if (total == 0) {
        return [
          PieChartSectionData(
            value: 50,
            color: Color(0xFFCC8B6E).withOpacity(0.9),
            title: '',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ];
      }
      return List.generate(3, (index) {
        return PieChartSectionData(
          value: values[index].toDouble(),
          color: colors[index],
          title: getPercentage(values[index]),
          radius: 50,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      });
    }

    //priority Type myticket
    List<PieChartSectionData> pieChartPirorityType() {
      final low = provider.myTicketSummary!.priorityLow;
      final medium = provider.myTicketSummary!.priorityMedium;
      final high = provider.myTicketSummary!.priorityHigh;
      final total = low + medium + high;

      String getPercentage(int value) {
        if (total == 0) return '0%';
        double percent = (value / total) * 100;
        return '${percent.toStringAsFixed(0)}%';
      }

      final List<int> values = [low, medium, high];
      final List<Color> colors = [primarySwatch, Colors.orange, Colors.red];
      if (total == 0) {
        return [
          PieChartSectionData(
            value: 50,
            color: Color(0xFFCC8B6E).withOpacity(0.9),
            title: '',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ];
      }
      return List.generate(3, (index) {
        return PieChartSectionData(
          value: values[index].toDouble(),
          color: colors[index],
          title: getPercentage(values[index]),
          radius: 50,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      });
    }

    // Check if data is still loading
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(child: Text(provider.errorMessage));
    }

    if (provider.myTicketSummary == null) {
      return Center(child: Text("No ticket summary available"));
    }

    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(), // Smooth scrolling effect
        child: Column(
          children: [
            // Summary Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SummaryCard(
                  title: "Open",
                  count: '${provider.myTicketSummary!.open}',
                  countColor: Colors.red,
                  screenWidth: screenWidth,
                ),
                SizedBox(
                  width: 10,
                ),
                SummaryCard(
                  title: "Closed",
                  count: '${provider.myTicketSummary!.closed}',
                  countColor: Colors.green,
                  screenWidth: screenWidth,
                ),
              ],
            ),
            const SizedBox(height: 16),

            Card(
              color: cardBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200, // Adjust width as needed
                        height: 200,
                        child: PieChart(PieChartData(
                          sections: pieChartServityType(),
                          sectionsSpace: 0,
                        )),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Severity Type',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primarySwatch),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _buildSeverityPriorityItem(
                              'Low',
                              provider.myTicketSummary!.severityLow,
                              primarySwatch),
                          SizedBox(
                            height: 5,
                          ),
                          _buildSeverityPriorityItem(
                              'Medium',
                              provider.myTicketSummary!.severityMedium,
                              Colors.orange),
                          SizedBox(
                            height: 5,
                          ),
                          _buildSeverityPriorityItem(
                              'High',
                              provider.myTicketSummary!.severityHigh,
                              Colors.red),
                        ],
                      ),
                    ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              color: cardBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200, // Adjust width as needed
                        height: 200,
                        child: PieChart(PieChartData(
                          sections: pieChartPirorityType(),
                          sectionsSpace: 0,
                        )),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Priority Type',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primarySwatch),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _buildSeverityPriorityItem(
                              'Low',
                              provider.myTicketSummary!.priorityLow,
                              primarySwatch),
                          SizedBox(
                            height: 5,
                          ),
                          _buildSeverityPriorityItem(
                              'Medium',
                              provider.myTicketSummary!.priorityMedium,
                              Colors.orange),
                          SizedBox(
                            height: 5,
                          ),
                          _buildSeverityPriorityItem(
                              'High',
                              provider.myTicketSummary!.priorityHigh,
                              Colors.red),
                        ],
                      ),
                    ]),
              ),
            ),

            const SizedBox(height: 16),

            // Average Duration for Work Completion
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                    "${provider.myTicketSummary!.averageCompletionRatePerDay}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primarySwatch[900]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

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
    );
  }

  Widget _buildSeverityPriorityItem(String label, int value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 8,
              backgroundColor: color,
              foregroundColor: color,
            ),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          '$value',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}
