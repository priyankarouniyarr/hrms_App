import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/custom_appbar.dart';

class PayrollScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: CustomAppBar(
          title: 'Payroll',
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Card(
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_left,
                                  color: primarySwatch)),
                          const Text('Sharwan,2081',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primarySwatch)),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_right,
                                color: primarySwatch[900]),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Basic Salary',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text('Rs 20000',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Allowance',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text(' Rs 0000',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 4.0,
                        dashColor: Colors.black,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Gross Total',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(' Rs 0000',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Net Total',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(' Rs 0000',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Text("Taxes",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8))),
            const SizedBox(
              height: 10,
            ),
            const Card(
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text('Sharwan,2081',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primarySwatch)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SST',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text('Rs 0',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('IncomeTax',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text(' Rs 0',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 4.0,
                        dashColor: Colors.black,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Deduction',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(' Rs 0',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            Text("Loan And Advances",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8))),
            const SizedBox(
              height: 10,
            ),
            const Card(
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Particular',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Amount',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Advance',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text('Rs 0',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Basishak 2081',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text(' Rs 0',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Jestha 2081',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text(' Rs 0',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ashad 2081',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text(' Rs 0',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 4.0,
                        dashColor: Colors.black,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('  Balance',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(' Rs 70000',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                )),
          ]),
        )));
  }
}
