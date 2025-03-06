import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/models/employee_contract.dart';
import 'package:hrms_app/providers/employee_contract_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class EmployementContracts extends StatefulWidget {
  const EmployementContracts({super.key});

  @override
  State<EmployementContracts> createState() => _EmployementContractsState();
}

class _EmployementContractsState extends State<EmployementContracts> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<EmployeeContractProvider>(context, listen: false)
            .fetchEmployeeContracts());
  }

  @override
  Widget build(BuildContext context) {
    final contractProvider = context.watch<EmployeeContractProvider>();

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: const CustomAppBarProfile(title: "Contracts"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: contractProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : contractProvider.contracts.isEmpty
                ? const Center(child: Text("No contracts available"))
                : ListView.builder(
                    itemCount: contractProvider.contracts.length,
                    itemBuilder: (context, index) {
                      EmployeeContract contract =
                          contractProvider.contracts[index];
                      return Card(
                        color: cardBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                  "Contract Type", contract.contractType),
                              _buildInfoRow(
                                  "From Date", contract.contractStartDateNp),
                              _buildInfoRow(
                                  "To Date", contract.contractEndDateNp),
                              _buildInfoRow(
                                  "Pay Package", contract.payPackageTitle),
                              _buildInfoRow("Level", contract.levelTitle),
                              _buildInfoRow("Status", contract.status),
                              _buildInfoRow("Expires In",
                                  " ${contract.expireInDays.toString()} days"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (title == "Status") // Check if it's the status field
            Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    value.toLowerCase() == "active" ? Colors.green : Colors.red,
              ),
            )
          else
            Text(value, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
