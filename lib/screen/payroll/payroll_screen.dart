import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/custom_appbar.dart';
import 'package:hrms_app/providers/payroll/payroll_provider.dart';
import 'package:hrms_app/providers/payroll/payroll_monthly_salarayy_provider.dart';

class PayrollScreen extends StatefulWidget {
  @override
  _PayrollScreenState createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  int currentMonth = NepaliDateTime.now().month; // Nepali month
  int currentYear = NepaliDateTime.now().year;
  void initState() {
    super.initState();

    Future.microtask(() {
      print(currentMonth);
      Provider.of<LoanAndAdvanceProvider>(context, listen: false)
          .fetchLoanAndAdvances();
      Provider.of<LoanAndAdvanceProvider>(context, listen: false)
          .fetchMyTaxes();

      Provider.of<SalaryProvider>(context, listen: false)
          .fetchCurrentMonthSalary();
    });
    //
  }

  void _fetchPreviousMonthSalary() {
    setState(() {
      if (currentMonth == 1) {
        currentMonth = 12;
        currentYear--;
      } else {
        currentMonth--;
      }

      print("Current Year: $currentYear,$currentMonth");
    });

    Provider.of<SalaryProvider>(context, listen: false)
        .fetchMonthSalary(currentMonth, currentYear);
  }

  void _fetchNextMonthSalary() {
    setState(() {
      if (currentMonth == 12) {
        currentMonth = 1;
        currentYear++;
      } else {
        currentMonth++;
      }

      print("Current Year: $currentYear,$currentMonth");
    });

    Provider.of<SalaryProvider>(context, listen: false)
        .fetchMonthSalary(currentMonth, currentYear);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoanAndAdvanceProvider>(context);
    final salaryProvider = Provider.of<SalaryProvider>(context);

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
            if (salaryProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (salaryProvider.errorMessage.isNotEmpty)
              Center(child: Text(salaryProvider.errorMessage))
            else if (salaryProvider.currentMonthSalary == null &&
                salaryProvider.monthSalary == null)
              const Center(
                  child: Text(
                'No salary data available.',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: accentColor),
              ))
            else
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
                                onPressed: _fetchPreviousMonthSalary,
                                icon: const Icon(Icons.arrow_left,
                                    color: Color.fromRGBO(19, 96, 164, 1))),
                            Text(
                              "${NepaliDateFormat('MMMM').format(NepaliDateTime(currentYear, currentMonth))} $currentYear",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primarySwatch),
                            ),
                            IconButton(
                              onPressed: _fetchNextMonthSalary,
                              icon: Icon(Icons.arrow_right,
                                  color: primarySwatch[900]),
                            ),
                          ],
                        ),
                      ),
                      if (salaryProvider
                                  .monthSalary?.monthlySalaryData.isEmpty ==
                              true ||
                          salaryProvider.currentMonthSalary?.monthlySalaryData
                                  .isEmpty ==
                              true)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No salary data available.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: accentColor,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        // List of Salary Items
                        ListView.builder(
                          shrinkWrap: true, // Add this
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: salaryProvider
                              .monthSalary?.monthlySalaryData.length,
                          itemBuilder: (context, index) {
                            final salaryData = salaryProvider
                                .monthSalary?.monthlySalaryData[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    salaryData!.payHead,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Rs ${salaryData.amount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: salaryData.additionOrDeduction ==
                                              "Addition"
                                          ? Colors.black
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  ' Rs ${salaryProvider.monthSalary?.netTotal}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Net Total',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  " Rs ${salaryProvider.monthSalary?.grossTotal}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ]
                    ],
                  )),
            const SizedBox(
              height: 20,
            ),

            // Taxes section
            Text(
              "Taxes",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.8)),
            ),
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
              Card(
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: provider.currentTaxIndex > 0
                                ? provider.prevTax
                                : null,
                            icon: Icon(
                              Icons.arrow_left,
                              color: provider.currentTaxIndex > 0
                                  ? primarySwatch
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            "${provider.currentTax?.month} ${provider.currentTax?.year}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: primarySwatch,
                            ),
                          ),
                          IconButton(
                            onPressed: provider.currentTaxIndex <
                                    provider.salaryDeductions.length - 1
                                ? provider.nextTax
                                : null,
                            icon: Icon(
                              Icons.arrow_right,
                              color: provider.currentTaxIndex <
                                      provider.salaryDeductions.length - 1
                                  ? primarySwatch
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('SST',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text('Rs ${provider.currentTax?.sst}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Income Tax',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text('Rs ${provider.currentTax?.incomeTax}',
                              style: const TextStyle(
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
                          Text('Rs ${provider.currentTax?.totalDeduction}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: accentColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
