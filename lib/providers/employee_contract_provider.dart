import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import '../models/profile_models/employee_contract.dart';

class EmployeeContractProvider with ChangeNotifier {
  List<EmployeeContract> _contracts = [];
  bool _isLoading = false;
  final SecureStorageService secureStorageService = SecureStorageService();

  List<EmployeeContract> get contracts => _contracts;
  bool get isLoading => _isLoading;
  String? errorMessage;

  Future<void> fetchEmployeeContracts() async {
    _isLoading = true;
    notifyListeners();

    try {
      String? token = await secureStorageService.readData('auth_token');
      String? branchId = await secureStorageService.readData('workingBranchId');

      if (token == null || branchId == null) {
        errorMessage = 'Token or BranchId is missing';
        _isLoading = false;
        notifyListeners(); // Notify listeners when an error occurs
        return;
      }
      final url = Uri.parse(
          'http://45.117.153.90:5004/api/EmployeeContract/GetEmployeeContracts');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'workingBranchId': branchId,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        _contracts =
            jsonResponse.map((e) => EmployeeContract.fromJson(e)).toList();
      } else {
        throw Exception(
            "Failed to load contracts. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching contracts: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
