import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/custom_appbar.dart';
import 'dart:async'; // Import for scheduleMicrotask
import 'package:hrms_app/providers/payroll_provider.dart';

class PayrollScreen extends StatefulWidget {
  @override
  _PayrollScreenState createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider =
          Provider.of<LoanAndAdvanceProvider>(context, listen: false);
      provider.fetchLoanAndAdvances();
      provider.fetchMyTaxes(); // Fetch taxes as well
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoanAndAdvanceProvider>(context);

    return Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: const CustomAppBar(
          title: 'Payroll',
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Basic salary and other details
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
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
                    const Padding(
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
                    const Padding(
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
            const SizedBox(
              height: 20,
            ),

            // Taxes section
            Text("Taxes",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8))),
            const SizedBox(
              height: 10,
            ),
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (provider.errorMessage.isNotEmpty)
              Center(child: Text(provider.errorMessage))
            else if (provider.salaryDeductions.isEmpty)
              const Center(child: Text('No tax data available.'))
            else
              ...provider.salaryDeductions.map((tax) {
                return Card(
                  color: backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          "(${tax.month} ${tax.year})",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('SST ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            Text('Rs ${tax.sst}',
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
                            Text('Income Tax',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            Text('Rs ${tax.incomeTax}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const Padding(
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Deduction',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Rs ${tax.totalDeduction}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: accentColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

            const SizedBox(
              height: 20,
            ),

            // Loan and Advances section
            Text("Loan And Advances",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8))),
            const SizedBox(
              height: 10,
            ),

            // Loan and Advances Card
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (provider.errorMessage.isNotEmpty)
              Center(child: Text(provider.errorMessage))
            else if (provider.loanAndAdvanceModel == null)
              const Center(
                  child: Text(
                      'No loan and advance data available.')) // Handle empty data case
            else
              Card(
                  color: backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
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
                      for (var item
                          in provider.loanAndAdvanceModel!.loanAndAdvanceData)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Rs ${item.amount}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: item.nature == '-'
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${item.nature}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: item.nature == '-'
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const Padding(
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Balance',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                                'Rs ${provider.loanAndAdvanceModel!.balanceAmount}',
                                style: const TextStyle(
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
