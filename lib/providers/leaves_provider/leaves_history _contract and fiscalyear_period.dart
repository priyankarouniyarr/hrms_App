import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/leaves/leave_history_models.dart';

class LeaveContractandFiscalYearProvider extends ChangeNotifier {
  List<LeaveContractPeriodAndFiscalYeAR> _leavecontractyear = [];
  List<LeaveContractPeriodAndFiscalYeAR> _leavefiscalyear = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();
  String? _branchId;
  String? _token;
  String? _fiscalYear;

  List<LeaveContractPeriodAndFiscalYeAR> get leaveFiscalYear =>
      _leavefiscalyear;
  List<LeaveContractPeriodAndFiscalYeAR> get leaveContractYear =>
      _leavecontractyear;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchEmployeeLeaveHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _branchId = await _secureStorageService.readData('workingBranchId');
      _token = await _secureStorageService.readData('auth_token');
      _fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (_token == null || _branchId == null || _fiscalYear == null) {
        _errorMessage = 'Missing required credentials';
        _isLoading = false;
        notifyListeners();
        return;
      }

      const String url3 =
          "http://45.117.153.90:5004/api/LeaveApplication/GetContractFiscalYearByContctId/3";
      const String url4 =
          "http://45.117.153.90:5004/api/LeaveApplication/GetContracts";

      final headers = {
        'Authorization': 'Bearer $_token',
        'workingBranchId': _branchId!,
        'workingFinancialId': _fiscalYear!,
      };

      final response4 = await http.get(Uri.parse(url3), headers: headers);
      final response5 = await http.get(Uri.parse(url4), headers: headers);

      if (response4.statusCode == 200 && response5.statusCode == 200) {
        final List<dynamic> jsonFiscalYear = json.decode(response4.body);

        final List<dynamic> jsoncontractPeriod = json.decode(response5.body);

        _leavefiscalyear = jsonFiscalYear
            .map((e) => LeaveContractPeriodAndFiscalYeAR.fromJson(e))
            .toList();

        _leavecontractyear = jsoncontractPeriod
            .map((e) => LeaveContractPeriodAndFiscalYeAR.fromJson(e))
            .toList();
      } else {
        _errorMessage = "Failed to fetch leave history";
      }
    } catch (error) {
      _errorMessage = "Error fetching leave history: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
