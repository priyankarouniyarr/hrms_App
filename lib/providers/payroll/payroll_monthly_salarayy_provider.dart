import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/models/payrolls_models/monthly_salary_models.dart';

class SalaryProvider with ChangeNotifier {
  GetMyCurrentMonthSalary? _currentMonthSalary;
  GetMyMonthSalary? _monthSalary;

  final SecureStorageService _secureStorageService = SecureStorageService();
  String _errorMessage = '';
  bool _isLoading = false;
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();

  GetMyCurrentMonthSalary? get currentMonthSalary => _currentMonthSalary;
  GetMyMonthSalary? get monthSalary => _monthSalary;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
  }

  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    debugPrint("Stored Base URL of payroll: $baseUrl");
  }

  Future<void> fetchCurrentMonthSalary() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      String? token = await _secureStorageService.readData('auth_token');
      String? branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      String? fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (token == null || branchId == null || fiscalYear == null) {
        throw Exception("Missing authentication data.");
      }
      final baseUrl = await _getBaseUrl();
      if (baseUrl == null) {
        _errorMessage = 'Base URL not found. Please enter hospital code again.';
        debugPrint(_errorMessage);
        _isLoading = false;
        notifyListeners();

        return;
      }

      // Store the base URL to ensure it’s persisted
      await _storeBaseUrl(baseUrl);

      final url = Uri.parse('$baseUrl/api/Payroll/GetMyCurrentMonthSalary');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'selected_workingbranchId': branchId,
          'selected_fiscal_year': fiscalYear,
        },
      );

      if (response.statusCode == 200) {
        _currentMonthSalary =
            GetMyCurrentMonthSalary.fromJson(json.decode(response.body));
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load notices';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
      print("Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch Salary for Specific Month
  Future<void> fetchMonthSalary(
    int month,
    int year,
  ) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      String? token = await _secureStorageService.readData('auth_token');
      String? branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      String? fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (token == null || branchId == null || fiscalYear == null) {
        _errorMessage = "Missing authentication data.";
        debugPrint(_errorMessage);
        _isLoading = false;
        notifyListeners();
        return;
      }

      final baseUrl = await _getBaseUrl();
      if (baseUrl == null) {
        _errorMessage = 'Base URL not found. Please enter hospital code again.';
        debugPrint(_errorMessage);
        _isLoading = false;

        return;
      }

      // Store the base URL to ensure it’s persisted
      await _storeBaseUrl(baseUrl);

      final request = GetMyMonthSalaryRequest(month: month, year: year);
      final response = await http.post(
        Uri.parse('$baseUrl/api/Payroll/GetMyMonthSalary'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'selected_workingbranchId': branchId,
          'selected_fiscal_year': fiscalYear,
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        _monthSalary = GetMyMonthSalary.fromJson(json.decode(response.body));
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load notices';
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
      print("Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
