import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/utlis/socket_handle.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/payrolls_models/loan_and_advance_data.dart';
import 'package:hrms_app/models/payrolls_models/salary_deduction_models.dart';

class LoanAndAdvanceProvider with ChangeNotifier {
  LoanAndAdvanceModel? _loanAndAdvanceModel;
  List<SalaryDeduction> _salaryDeductions = [];
  int _currentTaxIndex = 0; // Track the current index

  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();
  int get currentTaxIndex => _currentTaxIndex;

  LoanAndAdvanceModel? get loanAndAdvanceModel => _loanAndAdvanceModel;
  List<SalaryDeduction> get salaryDeductions => _salaryDeductions;

  SalaryDeduction? get currentTax =>
      _salaryDeductions.isNotEmpty ? _salaryDeductions[_currentTaxIndex] : null;
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
          await _secureStorageService.readData('selected_workingbranchId');
      String? fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (token == null && branchId == null && fiscalYear == null) {
        print("Token or Branch ID is missing");
        throw Exception("Token or Branch ID is missing.");
      }

      final url = Uri.parse(
          'http://45.117.153.90:5004/api/Payroll/GetMyLoanAndAdvances');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'selected_workingbranchId': branchId!,
          'selected_fiscal_year': fiscalYear!,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _loanAndAdvanceModel = LoanAndAdvanceModel.fromJson(data);
      } else {
        _errorMessage = 'Failed to fetch loan and advances: ${response.body}';
      }
      print("try block");
      // } on SocketException catch (_) {
      //   print("hlo");
      //   showSocketErrorDialog(
      //     context: context,
      //     onRetry: () => fetchLoanAndAdvances(context),
      //   );
      //   print("socket block");
      // }
    } catch (e) {}

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

      if (token == null && branchId == null && fiscalYear == null) {
        print("Token or Branch ID is missing");
        throw Exception("Token is missing.");
      }

      final url = Uri.parse('http://45.117.153.90:5004/api/Payroll/GetMyTaxes');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'selected_workingbranchId': branchId!,
          'selected_fiscal_year': fiscalYear!,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _salaryDeductions =
            data.map((json) => SalaryDeduction.fromJson(json)).toList();
      } else {
        _errorMessage = 'Failed to fetch taxes: ${response.body}';
      }
      // } on SocketException catch (_) {
      //   await showSocketErrorDialog(
      //     context: context,
      //     onRetry: () => fetchMyTaxes(context),
      //   );
      // }
    } catch (e) {
      _errorMessage = 'Error: $e';
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

  // Move to the previous tax record
  void prevTax() {
    if (_currentTaxIndex > 0) {
      _currentTaxIndex--;
      notifyListeners();
    }
  }
}
