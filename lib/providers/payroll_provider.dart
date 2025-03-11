import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/loan_and_advance_data.dart';
import 'package:hrms_app/screen/homescreen/salary_deduction_models.dart';

class LoanAndAdvanceProvider with ChangeNotifier {
  LoanAndAdvanceModel? _loanAndAdvanceModel;
  List<SalaryDeduction> _salaryDeductions = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();

  LoanAndAdvanceModel? get loanAndAdvanceModel => _loanAndAdvanceModel;
  List<SalaryDeduction> get salaryDeductions => _salaryDeductions;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  /// Fetch loan and advance data
  Future<void> fetchLoanAndAdvances() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      String? token = await _secureStorageService.readData('auth_token');
      String? branchId =
          await _secureStorageService.readData('workingBranchId');

      if (token == null || branchId == null) {
        throw Exception("Token or Branch ID is missing.");
      }

      final url = Uri.parse(
          'http://45.117.153.90:5004/api/Payroll/GetMyLoanAndAdvances');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'workingBranchId': branchId
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _loanAndAdvanceModel = LoanAndAdvanceModel.fromJson(data);
      } else {
        _errorMessage = 'Failed to fetch loan and advances: ${response.body}';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetch salary deductions (taxes)
  Future<void> fetchMyTaxes() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      String? token = await _secureStorageService.readData('auth_token');
      String? branchId =
          await _secureStorageService.readData('workingBranchId');

      if (token == null && branchId == null) {
        throw Exception("Token is missing.");
      }

      final url = Uri.parse('http://45.117.153.90:5004/api/Payroll/GetMyTaxes');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'workingBranchId': '$branchId',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _salaryDeductions =
            data.map((json) => SalaryDeduction.fromJson(json)).toList();
      } else {
        _errorMessage = 'Failed to fetch taxes: ${response.body}';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
