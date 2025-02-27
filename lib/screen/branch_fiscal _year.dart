import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/homescreen/homepage.dart';
import 'package:hrms_app/providers/branch_id_provider.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/providers/fiscal_year_provider.dart';

class SelectFiscalYearScreen extends StatefulWidget {
  @override
  _SelectFiscalYearScreenState createState() => _SelectFiscalYearScreenState();
}

class _SelectFiscalYearScreenState extends State<SelectFiscalYearScreen> {
  String? selectedFiscalYear;

  @override
  void initState() {
    super.initState();

    final branchProvider = Provider.of<BranchProvider>(context, listen: false);

    if (branchProvider.branches.isNotEmpty) {
      int branchId = branchProvider.branches.first.branchId;
      Provider.of<FiscalYearProvider>(context, listen: false)
          .fetchFiscalYears(branchId);
    } else {
      print("No branch ID available.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: primarySwatch[900],
        // toolbarHeight: 0,
        leading: BackButton(
          color: Colors.blue,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<FiscalYearProvider>(
            builder: (context, fiscalYearProvider, child) {
              if (fiscalYearProvider.loading) {
                return Center(child: CircularProgressIndicator());
              }

              if (fiscalYearProvider.errorMessage.isNotEmpty) {
                return Center(child: Text(fiscalYearProvider.errorMessage));
              }

              if (fiscalYearProvider.fiscalYears.isEmpty) {
                return Center(child: Text("No fiscal years available"));
              }

              List<String> fiscalYearNames = fiscalYearProvider.fiscalYears
                  .map((fiscalYear) => fiscalYear.financialYearCode)
                  .toList();

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Fiscal Year",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please select the fiscal year to continue",
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                  const SizedBox(height: 20),
                  CustomDropdown(
                    value: selectedFiscalYear,
                    items: fiscalYearNames,
                    hintText: "Select Fiscal Year",
                    onChanged: (value) {
                      setState(() {
                        selectedFiscalYear = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: selectedFiscalYear != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          }
                        : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: selectedFiscalYear != null
                            ? primarySwatch[900]
                            : primarySwatch.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: const Text(
                          "Next",
                          style: TextStyle(
                              color: backgroundColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
