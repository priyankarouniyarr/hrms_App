import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/leaves/apply_leave.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/models/leaves/leave_request_models.dart';

class LeaveRequestProvider extends ChangeNotifier {
  List<EmployeeRequest> _leaveTypePrimary = [];
  List<EmployeeRequest> _substitute = [];
  List<EmployeeRequest> _leaveTypeExtended = [];
  List<EmployeeRequest> _leaveEmployee = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();
  String? _branchId;
  String? _token;
  String? _fiscalYear;
  List<EmployeeRequest> get leaveEmployee => _leaveEmployee;
  List<EmployeeRequest> get leaveTypePrimary => _leaveTypePrimary;
  List<EmployeeRequest> get leaveTypeExtended => _leaveTypeExtended;
  List<EmployeeRequest> get substitute => _substitute;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
  }

  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    debugPrint("Stored Base URL of payroll: $baseUrl");
  }

  Future<void> fetchEmployeeLeaveApply() async {
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
      String leaveType = "$baseUrl/api/LeaveApplication/GetLeaveTypes";
      String extendedtype =
          "$baseUrl/api/LeaveApplication/GetExtendedLeaveTypes";

      String substitutionEmployee =
          "$baseUrl/api/LeaveApplication/GetSubstitutionEmployee";
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

//get api
  Future<void> fetchEmployeeLeaves() async {
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

      String employeeLeaves = "$baseUrl/api/LeaveApplication/EmployeeLeaves";
      final headers = {
        'Authorization': 'Bearer $_token',
        'workingBranchId': _branchId!,
        'workingFinancialId': _fiscalYear!,
      };

      final responseEmployee =
          await http.get(Uri.parse(employeeLeaves), headers: headers);

      if (responseEmployee.statusCode == 200) {
        final List<dynamic> jsonEmployeeLeaves =
            json.decode(responseEmployee.body);

        _leaveEmployee =
            jsonEmployeeLeaves.map((e) => EmployeeRequest.fromJson(e)).toList();
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

  //post api for leave request

  Future<bool> leaveApplyEmployee(
    LeaveApplicationRequest request,
  ) async {
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
        return false;
      }
      final baseUrl = await _getBaseUrl();
      if (baseUrl == null) {
        _errorMessage = 'Base URL not found. Please enter hospital code again.';
        debugPrint(_errorMessage);
        _isLoading = false;
        notifyListeners();

        return false;
      }

      // Store the base URL to ensure it’s persisted
      await _storeBaseUrl(baseUrl);
      final url =
          Uri.parse('$baseUrl/api/LeaveApplication/LeaveApplicationPost');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
        'workingBranchId': _branchId!,
        'workingFinancialId': _fiscalYear!,
      };

      final requestBody = json.encode(request.toJson());
    

      final response = await http.post(
        url,
        headers: headers,
        body: requestBody,
      );

     

      if (response.statusCode == 200) {
        if (response.body.toLowerCase() == 'true') {
          _errorMessage = 'yes';
          return true;
        } else if (response.body.toLowerCase() == 'false') {
          _errorMessage = 'Server rejected the leave application';
          return false;
        } else {
          // Try to parse as JSON
          try {
            final responseData = json.decode(response.body);
            if (responseData['success'] == true) {
             
              return true;
            } else {
            
              _errorMessage =
                  responseData['message'] ?? 'Leave application failed';
              return false;
            }
          } catch (e) {
          
            _errorMessage = 'Unexpected response format: ${response.body}';
            return false;
          }
        }
      } else {
    
        _errorMessage = 'Request failed with status ${response.statusCode}';
        return false;
      }
    } catch (error) {
  
      _errorMessage = "Error creating leave application: $error";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
