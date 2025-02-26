import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/custom_appbar.dart';
import 'package:hrms_app/screen/leaves/leavehistorypage.dart';
import 'package:hrms_app/screen/leaves/leaves_requestscreen.dart';

class LeavesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBar(title: "Leaves"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(3), //  Title column
                    1: FlexColumnWidth(2), // Available column
                    2: FlexColumnWidth(2), //  Total column
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: primarySwatch.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      children: [
                        _buildTableHeader('Title'),
                        _buildTableHeader('Available'),
                        _buildTableHeader('Total'),
                      ],
                    ),
                    _buildTableRow('Home Leave', '0', '0'),
                    _buildTableRow('Sick Leave', '0', '0'),
                    _buildTableRow('Leave Without Pay', '0', '0'),
                    _buildTableRow('Satta Bida', '0', '0'),
                    _buildTableRow('Paternity Leave', '0', '0'),
                    _buildTableRow('Maternity Leave\n Long Sentence', '0', '0'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // Add logic to apply leave
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LeavesRequestscreen()));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: primarySwatch[900],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Apply Leave',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: cardBackgroundColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Not Approved Leaves',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(child: Text('No leave requests found.')),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Approved Leaves',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(child: Text('No leave requests found.')),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeaveStatementScreen()));
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
                      'View Leave Statements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cardBackgroundColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String title, String available, String total) {
    return TableRow(
      children: [
        _buildTableCell(title),
        _buildTableCell(available),
        _buildTableCell(total),
      ],
    );
  }

  // Function to build table header cell
  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  // Function to build table data cell
  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        text,
        textAlign: TextAlign.left,
      ),
    );
  }
}
