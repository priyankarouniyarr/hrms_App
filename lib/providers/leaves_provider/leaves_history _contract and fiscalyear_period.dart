import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/models/leaves/leave_history_models.dart';


class LeaveContractandFiscalYearProvider extends ChangeNotifier {
  List<LeaveContractPeriodAndFiscalYeAR> _leaveContractList = [];
  List<LeaveContractPeriodAndFiscalYeAR> _leaveFiscalYearList = [];
  List<Leave> _leavefiscalandcontractId = [];
  List<LeaveApplication> _leavecontractandfiscalIdDetails = [];

  bool _isLoading = false;
  String _errorMessage = '';
  final SecureStorageService _secureStorageService = SecureStorageService();

  String? _branchId;
  String? _token;
  String? _fiscalYear;
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();
  List<LeaveContractPeriodAndFiscalYeAR> get leaveFiscalYearList =>
      _leaveFiscalYearList;
  List<LeaveContractPeriodAndFiscalYeAR> get leaveContractList =>
      _leaveContractList;
  List<Leave> get leavefiscalandcontractId => _leavefiscalandcontractId;
  List<LeaveApplication> get leavecontractandfiscalIdDetails =>
      _leavecontractandfiscalIdDetails;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
  }

  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    debugPrint("Stored Base URL of leave : $baseUrl");
  }

  ///  Fetch all contracts (Initial Call)
  Future<void> fetchLeaveContracts() async {
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
      String urlGetContracts = "$baseUrl/api/LeaveApplication/GetContracts";

      final headers = {
        'Authorization': 'Bearer $_token',
        'workingBranchId': _branchId!,
        'workingFinancialId': _fiscalYear!,
      };

      final response =
          await http.get(Uri.parse(urlGetContracts), headers: headers);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> contractListJson = json.decode(response.body);
        _leaveContractList = contractListJson
            .map((e) => LeaveContractPeriodAndFiscalYeAR.fromJson(e))
            .toList();
        notifyListeners();
      } else {
        _errorMessage = "Failed to fetch contract data";
      }
    } catch (error) {
      _errorMessage = "Error fetching contracts: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch Fiscal Year by passing the contractId
  Future<void> fetchFiscalYearByContractId({
    required int contractId,
  }) async {
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
      final String urlFiscalYear =
          "$baseUrl/api/LeaveApplication/GetContractFiscalYearByContctId/$contractId";

      final headers = {
        'Authorization': 'Bearer $_token',
        'workingBranchId': _branchId!,
        'workingFinancialId': _fiscalYear!,
      };

      final response =
          await http.get(Uri.parse(urlFiscalYear), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> fiscalYearListJson = json.decode(response.body);
        _leaveFiscalYearList = fiscalYearListJson
            .map((e) => LeaveContractPeriodAndFiscalYeAR.fromJson(e))
            .toList();
        notifyListeners();
      } else {
        _errorMessage = "Failed to fetch fiscal year data";
      }
    } on SocketException catch (e) {
      if (e.osError != null && e.osError!.errorCode == 101) {
        _errorMessage =
            'Network is unreachable. Please check your internet connection.';
      } else {
        _errorMessage = 'Network error: ${e.message}';
      }
      print("SocketException: $_errorMessage");
    } catch (error) {
      _errorMessage = "Error fetching fiscal year: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch Fiscal Year by passing the contractId and fiscalYearId
  Future<void> fetchFiscalYearByContractIdandFiscalYearId({
    required int contractId,
    required int fiscalYearId,
  }) async {
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

      final String urlContractandFiscalYear =
          "$baseUrl/api/LeaveApplication/EmployeeLeaveHistoryByContractIdAndFiscalYearId/$contractId/$fiscalYearId"; //table to get
      final String employeeLeavesByContractIdAndFiscalYearId =
          "$baseUrl/api/LeaveApplication/EmployeeLeavesByContractIdAndFiscalYearId/$contractId/$fiscalYearId"; //leave details
      final headers = {
        'Authorization': 'Bearer $_token',
        'workingBranchId': _branchId!,
        'workingFinancialId': _fiscalYear!,
      };

      final response =
          await http.get(Uri.parse(urlContractandFiscalYear), headers: headers);
      final responseLeaves = await http.get(
          Uri.parse(employeeLeavesByContractIdAndFiscalYearId),
          headers: headers);
      //print(responseLeaves.body);

      if (response.statusCode == 200 && responseLeaves.statusCode == 200) {
        final List<dynamic> contractandFiscalJson = json.decode(response.body);
        _leavefiscalandcontractId = contractandFiscalJson
            .map((e) => Leave.fromJson(e))
            .toList(); //table

//leaves details

        final List<dynamic> leavecontractandFiscalJson =
            json.decode(responseLeaves.body);
        //  print("hlo");
        // print(leavecontractandFiscalJson);

        _leavecontractandfiscalIdDetails = leavecontractandFiscalJson
            .map((e) => LeaveApplication.fromJson(e))
            .toList();
//
        //   print(_leavecontractandfiscalIdDetails);
        print("hello");
        notifyListeners();
      } else {
        _errorMessage = "Failed to fetch fiscal year data";
      }
    } catch (error) {
      print(error);
      _errorMessage = "Error fetching fiscal year: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
