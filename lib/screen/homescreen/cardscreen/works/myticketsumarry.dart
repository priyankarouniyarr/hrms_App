import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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

    // Check if data is still loading
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(child: Text(provider.errorMessage));
    }
    final List<ChartData> severityData = [
      ChartData('Low', 1, Colors.blue),
      ChartData('Medium', 12, Colors.orange),
      ChartData('High', 18, Colors.red),
    ];

    final List<ChartData> priorityData = [
      ChartData('Low', 1, Colors.blue),
      ChartData('Medium', 11, Colors.orange),
      ChartData('High', 17, Colors.red),
    ];
    // Check if ticket data is available

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

            // Center(
            //   child: Text(
            //     "No data available",
            //     style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            //   ),
            // ),
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildChartCard('Severity Type', severityData),
                const SizedBox(height: 20),
                _buildChartCard('Priority Type', priorityData),
              ],
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

  Widget _buildChartCard(String title, List<ChartData> data) {
    int total = data.fold(0, (sum, item) => sum + item.value);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: SfCircularChart(
              annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                  widget: Container(),
                ),
              ],
              series: <DoughnutSeries<ChartData, String>>[
                DoughnutSeries<ChartData, String>(
                  dataSource: data,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  pointColorMapper: (ChartData data, _) => data.color,
                  dataLabelMapper: (ChartData data, _) {
                    double percent = (data.value / total) * 100;
                    return '${percent.toStringAsFixed(0)}%';
                  },
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  radius: '90%',
                  innerRadius: '70%',
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                const SizedBox(height: 12),
                ...data.map((d) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            color: d.color,
                          ),
                          const SizedBox(width: 8),
                          Text(d.label, style: const TextStyle(fontSize: 16)),
                          const Spacer(),
                          Text('${d.value}',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChartData {
  final String label;
  final int value;
  final Color color;
  ChartData(this.label, this.value, this.color);
}
