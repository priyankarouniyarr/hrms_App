import 'package:flutter/material.dart';
import '../storage/securestorage.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/app_main_screen.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/providers/branch_id_providers/branch_id_provider.dart';
import 'package:hrms_app/providers/fiscal_year_provider/fiscal_year_provider.dart';

class SelectFiscalYearScreen extends StatefulWidget {
  @override
  _SelectFiscalYearScreenState createState() => _SelectFiscalYearScreenState();
}

class _SelectFiscalYearScreenState extends State<SelectFiscalYearScreen> {
  int? selectedFiscalYear;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final branchProvider =
          Provider.of<BranchProvider>(context, listen: false);

      if (branchProvider.branches.isNotEmpty) {
        int branchId = branchProvider.branches.first.branchId;
        Provider.of<FiscalYearProvider>(context, listen: false)
            .fetchFiscalYears(branchId);
      } else {
        print("No branch ID available.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fiscalYearProvider =
        Provider.of<FiscalYearProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.blue),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(
            builder: (context) {
              if (fiscalYearProvider.loading) {
                return Center(child: CircularProgressIndicator());
              }

              if (fiscalYearProvider.errorMessage.isNotEmpty) {
                return Center(child: Text(fiscalYearProvider.errorMessage));
              }

              if (fiscalYearProvider.fiscalYears.isEmpty) {
                return Center(child: Text("No fiscal years available"));
              }

              List<Map<String, dynamic>> fiscalYearNames = fiscalYearProvider
                  .fiscalYears
                  .map((fiscalYear) => {
                        'label': fiscalYear.financialYearCode,
                        'value': fiscalYear.financialYearId
                      })
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
                  CustomDropdown2(
                    value: selectedFiscalYear,
                    items: fiscalYearNames,
                    hintText: "Select Fiscal Year",
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedFiscalYear = value;
                        });
                        SecureStorageService().writeData(
                            "selected_fiscal_year", value.toString());
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: selectedFiscalYear != null
                        ? () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AppMainScreen()),
                                (route) => false);
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
                        child: Text(
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
