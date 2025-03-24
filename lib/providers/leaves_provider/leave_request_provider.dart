import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/leaves/leave_request_models.dart';
import 'package:hrms_app/models/leaves/leave_history_models.dart';

class LeaveRequestProvider extends ChangeNotifier {
  List<EmployeeRequest> _leaveTypePrimary = [];
  List<EmployeeRequest> _substitute = [];
  List<EmployeeRequest> _leaveTypeExtended = [];

  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();
  String? _branchId;
  String? _token;
  String? _fiscalYear;

  List<EmployeeRequest> get leaveTypePrimary => _leaveTypePrimary;
  List<EmployeeRequest> get leaveTypeExtended => _leaveTypeExtended;
  List<EmployeeRequest> get substitute => _substitute;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchEmployeeLeaveApply() async {
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

      const String leaveType =
          "http://45.117.153.90:5004/api/LeaveApplication/GetLeaveTypes";
      const String extendedtype =
          "http://45.117.153.90:5004/api/LeaveApplication/GetExtendedLeaveTypes";

      const String substitutionEmployee =
          "http://45.117.153.90:5004/api/LeaveApplication/GetSubstitutionEmployee";
      final headers = {
        'Authorization': 'Bearer $_token',
        'workingBranchId': _branchId!,
        'workingFinancialId': _fiscalYear!,
      };

      final response4 = await http.get(Uri.parse(leaveType), headers: headers);
      final response5 =
          await http.get(Uri.parse(extendedtype), headers: headers);
      final response6 =
          await http.get(Uri.parse(substitutionEmployee), headers: headers);

      if (response4.statusCode == 200 &&
          response5.statusCode == 200 &&
          response6.statusCode == 200) {
        final List<dynamic> jsonLeavePrimaryType = json.decode(response4.body);

        final List<dynamic> jsonExtendedType = json.decode(response5.body);
        final List<dynamic> jsonSubstitute = json.decode(response6.body);

        _leaveTypePrimary = jsonLeavePrimaryType
            .map((e) => EmployeeRequest.fromJson(e))
            .toList();

        _leaveTypeExtended =
            jsonExtendedType.map((e) => EmployeeRequest.fromJson(e)).toList();
        _substitute =
            jsonSubstitute.map((e) => EmployeeRequest.fromJson(e)).toList();
        notifyListeners();
      } else {
        _errorMessage = "Failed to fetch leave history";
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = "Error fetching leave history: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
