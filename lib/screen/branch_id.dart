import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/branch_id_provider.dart';
import 'package:hrms_app/screen/branch_fiscal%20_year.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';

class SelectBranchScreen extends StatefulWidget {
  @override
  _SelectBranchScreenState createState() => _SelectBranchScreenState();
}

class _SelectBranchScreenState extends State<SelectBranchScreen> {
  String? selectedBranch;

  @override
  void initState() {
    super.initState();

    Future.microtask(() => Provider.of<BranchProvider>(context, listen: false)
        .fetchUserBranches());
  }

  @override
  Widget build(BuildContext context) {
    final branchProvider = Provider.of<BranchProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarySwatch[900],
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: branchProvider.loading
              ? const Center(child: CircularProgressIndicator())
              : branchProvider.errorMessage.isNotEmpty
                  ? Center(child: Text(branchProvider.errorMessage))
                  : branchProvider.branches.isEmpty
                      ? const Center(child: Text("No branches available"))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Select Branch ID",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Please select the branch ID to continue",
                              style: TextStyle(
                                  fontSize: 16, color: secondaryColor),
                            ),
                            const SizedBox(height: 20),

                            CustomDropdown(
                              value: selectedBranch,
                              items: branchProvider.branches
                                  .map((branch) => branch.branchName)
                                  .toList(),
                              hintText: "Select Branch ID",
                              onChanged: (value) {
                                setState(() {
                                  selectedBranch = value;
                                });
                              },
                            ),
                            const SizedBox(height: 20),

                            // Next Button
                            GestureDetector(
                              onTap: selectedBranch != null
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SelectFiscalYearScreen(),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  color: selectedBranch != null
                                      ? primarySwatch[900]
                                      : primarySwatch.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                      color: backgroundColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
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
}
