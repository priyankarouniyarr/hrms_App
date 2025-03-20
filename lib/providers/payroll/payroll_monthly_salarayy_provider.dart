import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/payrolls_models/monthly_salary_models.dart';

class SalaryProvider with ChangeNotifier {
  GetMyCurrentMonthSalary? _currentMonthSalary;
  GetMyMonthSalary? _monthSalary;

  final SecureStorageService _secureStorageService = SecureStorageService();
  String _errorMessage = '';
  bool _isLoading = false;

  // Getters
  GetMyCurrentMonthSalary? get currentMonthSalary => _currentMonthSalary;
  GetMyMonthSalary? get monthSalary => _monthSalary;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Fetch Current Month Salary
  Future<void> fetchCurrentMonthSalary() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      String? token = await _secureStorageService.readData('auth_token');
      String? branchId =
          await _secureStorageService.readData('workingBranchId');
      String? fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (token == null || branchId == null || fiscalYear == null) {
        throw Exception("Missing authentication data.");
      }

      final url = Uri.parse(
          'http://45.117.153.90:5004/api/Payroll/GetMyCurrentMonthSalary');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'workingBranchId': branchId,
          'workingFinancialId': fiscalYear,
        },
      );

      if (response.statusCode == 200) {
        _currentMonthSalary =
            GetMyCurrentMonthSalary.fromJson(json.decode(response.body));
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load current month salary';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch Salary for Specific Month
  Future<void> fetchMonthSalary(int month, int year) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      String? token = await _secureStorageService.readData('auth_token');
      String? branchId =
          await _secureStorageService.readData('workingBranchId');
      String? fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (token == null || branchId == null || fiscalYear == null) {
        throw Exception("Missing authentication data.");
      }

      final request = GetMyMonthSalaryRequest(month: month, year: year);
      final response = await http.post(
        Uri.parse('http://45.117.153.90:5004/api/Payroll/GetMyMonthSalary'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'workingBranchId': branchId,
          'workingFinancialId': fiscalYear,
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        _monthSalary = GetMyMonthSalary.fromJson(json.decode(response.body));
        print(_monthSalary!.grossTotal);
        print(_monthSalary!.month);
        print(_monthSalary!.year);
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load month salary';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
