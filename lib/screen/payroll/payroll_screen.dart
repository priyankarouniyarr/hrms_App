import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/widget/custom_appbar.dart';
import 'package:hrms_app/providers/payroll/payroll_provider.dart';
import 'package:hrms_app/providers/payroll/payroll_monthly_salarayy_provider.dart';

class PayrollScreen extends StatefulWidget {
  @override
  _PayrollScreenState createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  int currentMonth = NepaliDateTime.now().month;
  int currentYear = NepaliDateTime.now().year;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    try {
      final loanProvider =
          Provider.of<LoanAndAdvanceProvider>(context, listen: false);
      final salaryProvider =
          Provider.of<SalaryProvider>(context, listen: false);

      // Load data sequentially to avoid race conditions
      await loanProvider.fetchLoanAndAdvances();
      await loanProvider.fetchMyTaxes();
      await salaryProvider.fetchCurrentMonthSalary();
      await salaryProvider.fetchMonthSalary(currentMonth, currentYear);
    } catch (e) {
      debugPrint('Initial data loading error: $e');
    } finally {
      if (mounted) {
        setState(() => _isInitialLoad = false);
      }
    }
  }

  Future<void> _fetchPreviousMonthSalary() async {
    int newMonth = currentMonth;
    int newYear = currentYear;

    if (newMonth == 1) {
      newMonth = 12;
      newYear--;
    } else {
      newMonth--;
    }

    await Provider.of<SalaryProvider>(context, listen: false).fetchMonthSalary(
      newMonth,
      newYear,
    );

    if (mounted) {
      setState(() {
        currentMonth = newMonth;
        currentYear = newYear;
      });
    }
  }

  Future<void> _fetchNextMonthSalary() async {
    int newMonth = currentMonth;
    int newYear = currentYear;

    if (newMonth == 12) {
      newMonth = 1;
      newYear++;
    } else {
      newMonth++;
    }

    await Provider.of<SalaryProvider>(context, listen: false).fetchMonthSalary(
      newMonth,
      newYear,
    );

    if (mounted) {
      setState(() {
        currentMonth = newMonth;
        currentYear = newYear;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: const CustomAppBar(title: 'Payroll'),
      body: _isInitialLoad
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSalarySection(),
                    const SizedBox(height: 20),
                    _buildTaxesSection(),
                    const SizedBox(height: 20),
                    _buildLoanAdvancesSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSalarySection() {
    return Consumer<SalaryProvider>(
      builder: (context, salaryProvider, child) {
        return Card(
          color: backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: _fetchPreviousMonthSalary,
                      icon: const Icon(Icons.arrow_left,
                          color: Color.fromRGBO(19, 96, 164, 1)),
                    ),
                    Text(
                      "${NepaliDateFormat('MMMM').format(NepaliDateTime(currentYear, currentMonth))} $currentYear",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primarySwatch,
                      ),
                    ),
                    IconButton(
                      onPressed: _fetchNextMonthSalary,
                      icon: Icon(Icons.arrow_right, color: primarySwatch[900]),
                    ),
                  ],
                ),
              ),
              if (salaryProvider.monthSalary?.monthlySalaryData.isEmpty == true)
                _buildNoDataMessage('No salary data available')
              else if (salaryProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (salaryProvider.errorMessage.isNotEmpty)
                _buildNoDataMessage(salaryProvider.errorMessage)
              else ...[
                _buildSalaryItems(salaryProvider),
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
                _buildSalaryTotalRow('Gross Total',
                    salaryProvider.monthSalary?.grossTotal.toString()),
                _buildSalaryTotalRow('Net Total',
                    salaryProvider.monthSalary?.grossTotal.toString()),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSalaryItems(SalaryProvider salaryProvider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: salaryProvider.monthSalary?.monthlySalaryData.length ?? 0,
      itemBuilder: (context, index) {
        final salaryData = salaryProvider.monthSalary?.monthlySalaryData[index];
        if (salaryData == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                salaryData.payHead,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                'Rs ${salaryData.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: salaryData.additionOrDeduction == "Addition"
                      ? Colors.black
                      : Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSalaryTotalRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('Rs ${value ?? '0.00'}',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTaxesSection() {
    return Consumer<LoanAndAdvanceProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Taxes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 10),
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (provider.errorMessage.isNotEmpty)
              Center(
                  child: Text(
                provider.errorMessage,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: accentColor,
                ),
                textAlign: TextAlign.justify,
              ))
            else if (provider.salaryDeductions.isEmpty)
              _buildNoDataMessage('No tax data available')
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
                                ? () {
                                    provider.prevTax();
                                  }
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
                                ? () {
                                    provider.nextTax();
                                  }
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
                    _buildTaxRow('SST', provider.currentTax?.sst.toString()),
                    _buildTaxRow('Income Tax',
                        provider.currentTax?.incomeTax.toString()),
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
          ],
        );
      },
    );
  }

  Widget _buildTaxRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text('Rs ${value ?? '0.00'}',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildLoanAdvancesSection() {
    return Consumer<LoanAndAdvanceProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Loan And Advances",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 10),
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (provider.errorMessage.isNotEmpty)
              Center(
                  child: Text(
                provider.errorMessage,
                style: TextStyle(
                    fontSize: 14,
                    color: accentColor,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.justify,
              ))
            else if (provider.loanAndAdvanceModel == null)
              _buildNoDataMessage('No loan and advance data available')
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
                    ...(provider.loanAndAdvanceModel?.loanAndAdvanceData ?? [])
                        .map(
                      (item) => Padding(
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
                                const SizedBox(width: 5),
                                Text(
                                  item.nature,
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
                              'Rs ${provider.loanAndAdvanceModel?.balanceAmount}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildNoDataMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: accentColor,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
