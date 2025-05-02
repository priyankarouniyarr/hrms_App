import 'package:flutter/material.dart';
import '../storage/securestorage.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/branch_fiscal%20_year.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/providers/branch_id_providers/branch_id_provider.dart';

class SelectBranchScreen extends StatefulWidget {
  @override
  _SelectBranchScreenState createState() => _SelectBranchScreenState();
}

class _SelectBranchScreenState extends State<SelectBranchScreen> {
  int? selectedBranch;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<BranchProvider>(context, listen: false)
        .fetchUserBranches());
  }

  @override
  Widget build(BuildContext context) {
    final branchProvider = Provider.of<BranchProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.blue),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(
            builder: (context) {
              if (branchProvider.loading) {
                return Center(child: CircularProgressIndicator());
              }

              if (branchProvider.errorMessage.isNotEmpty) {
                return Center(child: Text(branchProvider.errorMessage));
              }

              List<Map<String, dynamic>> branchname = branchProvider.branches
                  .map((branch) => {
                        'label': branch.branchName,
                        'value': branch.branchId,
                      })
                  .toList();

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Branch ID",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please select the branch ID to continue",
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                  const SizedBox(height: 20),
                  CustomDropdown2(
                    value: selectedBranch,
                    items: branchname,
                    hintText: "Select Branch ID",
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedBranch = value;
                        });
                        SecureStorageService().writeData(
                            "selected_workingbranchId", value.toString());
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: selectedBranch != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectFiscalYearScreen(),
                              ),
                            );
                          }
                        : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: selectedBranch != null
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
