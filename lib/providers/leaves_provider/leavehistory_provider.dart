import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/models/leaves/leave_history_models.dart';

class LeaveProvider extends ChangeNotifier {
  List<Leave> _leaves = [];
  List<LeaveApplication> _leaveApproval = [];
  List<LeaveApplication> _leaveNotApproval = [];
  List<LeaveContractPeriodAndFiscalYeAR> _leavecontractyear = [];
  List<LeaveContractPeriodAndFiscalYeAR> _leavefiscalyear = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();
  String? _branchId;
  String? _token;
  String? _fiscalYear;

  List<Leave> get leaves => _leaves;
  List<LeaveContractPeriodAndFiscalYeAR> get leaveFiscalYear =>
      _leavefiscalyear;
  List<LeaveContractPeriodAndFiscalYeAR> get leaveContractYear =>
      _leavecontractyear;
  List<LeaveApplication> get leaveApprovals => _leaveApproval;
  List<LeaveApplication> get leaveNotApprovals => _leaveNotApproval;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
  }

  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    debugPrint("Stored Base URL of payroll: $baseUrl");
  }

  Future<void> fetchEmployeeLeaveHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _branchId =
          await _secureStorageService.readData('selected_workingbranchId');
      _token = await _secureStorageService.readData('auth_token');
      _fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (_token == null || _branchId == null || _fiscalYear == null) {
        _errorMessage = 'Missing required credentials';
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
      String url = "$baseUrl/api/LeaveApplication/EmployeeLeaveHistory";
      String url1 =
          "$baseUrl/api/LeaveApplication/ApprovedEmployeeLeavesToCome";

      String url2 =
          "$baseUrl/api/LeaveApplication/NotApprovedEmployeeLeavesToCome";

      final headers = {
        'Authorization': 'Bearer $_token',
        'workingBranchId': _branchId!,
        'workingFinancialId': _fiscalYear!,
      };

      final response = await http.get(Uri.parse(url), headers: headers);
      final response2 = await http.get(Uri.parse(url1), headers: headers);
      final response3 = await http.get(Uri.parse(url2), headers: headers);

      if (response.statusCode == 200 &&
          response2.statusCode == 200 &&
          response3.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final List<dynamic> jsonApprovalData = json.decode(response2.body);

        final List<dynamic> jsonNotApprovalData = json.decode(response3.body);

        _leaves = jsonData.map((e) => Leave.fromJson(e)).toList();

        _leaveApproval =
            jsonApprovalData.map((e) => LeaveApplication.fromJson(e)).toList();

        _leaveNotApproval = jsonNotApprovalData
            .map((e) => LeaveApplication.fromJson(e))
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
