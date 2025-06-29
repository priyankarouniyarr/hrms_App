import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/models/payrolls_models/loan_and_advance_data.dart';
import 'package:hrms_app/models/payrolls_models/salary_deduction_models.dart';

class LoanAndAdvanceProvider with ChangeNotifier {
  LoanAndAdvanceModel? _loanAndAdvanceModel;
  List<SalaryDeduction> _salaryDeductions = [];
  int _currentTaxIndex = 0;

  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();

  int get currentTaxIndex => _currentTaxIndex;
  LoanAndAdvanceModel? get loanAndAdvanceModel => _loanAndAdvanceModel;
  List<SalaryDeduction> get salaryDeductions => _salaryDeductions;
  SalaryDeduction? get currentTax =>
      _salaryDeductions.isNotEmpty ? _salaryDeductions[_currentTaxIndex] : null;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
  }

  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    debugPrint("Stored Base URL: $baseUrl");
  }

  /// Fetch loan and advance data
  Future<void> fetchLoanAndAdvances() async {
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

      debugPrint("Token: $token");
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
      //debugPrint("Base URL: $baseUrl");

      final url = Uri.parse('$baseUrl/api/Payroll/GetMyLoanAndAdvances');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'selected_workingbranchId': branchId,
          'selected_fiscal_year': fiscalYear,
        },
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _loanAndAdvanceModel = LoanAndAdvanceModel.fromJson(data);
        debugPrint("LoanAndAdvanceModel: $_loanAndAdvanceModel");
      } else {
        _errorMessage = 'Failed to load loan and advance data';
        debugPrint(_errorMessage);
      }
    } catch (error) {
      _errorMessage = 'Error parsing loan and advance data: $error';
      debugPrint(_errorMessage);
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
        notifyListeners();

        return;
      }

      // Store the base URL to ensure it’s persisted
      await _storeBaseUrl(baseUrl);

      final url = Uri.parse('$baseUrl/api/Payroll/GetMyTaxes');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'selected_workingbranchId': branchId,
          'selected_fiscal_year': fiscalYear,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _salaryDeductions =
            data.map((json) => SalaryDeduction.fromJson(json)).toList();
      } else {
        _errorMessage = 'Failed to fetch taxes: ${response.body}';
        debugPrint(_errorMessage);
      }
    } on SocketException catch (e) {
      if (e.osError != null && e.osError!.errorCode == 101) {
        _errorMessage =
            'Network is unreachable. Please check your internet connection.';
      } else {
        _errorMessage = 'Network error: ${e.message}';
      }
      debugPrint("SocketException: $_errorMessage");
    } catch (error) {
      _errorMessage = 'Error: $error';
      debugPrint(_errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }

  void nextTax() {
    if (_currentTaxIndex < _salaryDeductions.length - 1) {
      _currentTaxIndex++;
      notifyListeners();
    }
  }

  void prevTax() {
    if (_currentTaxIndex > 0) {
      _currentTaxIndex--;
      notifyListeners();
    }
  }
}
