import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import '../../models/profile_models/employee_contract.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';

class EmployeeContractProvider with ChangeNotifier {
  List<EmployeeContract> _contracts = [];
  bool _isLoading = false;
  final SecureStorageService secureStorageService = SecureStorageService();
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();
  List<EmployeeContract> get contracts => _contracts;
  bool get isLoading => _isLoading;
  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
  }

  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    log("Stored Base URL: $baseUrl");
  }

  Future<void> fetchEmployeeContracts(
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Access HospitalCodeProvider to get baseUrl
      final baseUrl = await _getBaseUrl();
      if (baseUrl == null) {
        _errorMessage = 'Base URL not found. Please enter hospital code again.';
        debugPrint(errorMessage);
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Store the base URL to ensure it’s persisted
      await _storeBaseUrl(baseUrl);

      String? token = await secureStorageService.readData('auth_token');
      String? branchId =
          await secureStorageService.readData('selected_workingbranchId');
      String? fiscalYear =
          await secureStorageService.readData('selected_fiscal_year');
      log("branchId: $branchId");

      log("fiscalYear: $fiscalYear");
      log("token: $token");
      if (token == null || branchId == null || fiscalYear == null) {
        _errorMessage = 'Token or BranchId is missing';
        _isLoading = false;
        print(errorMessage);
        notifyListeners(); // Notify listeners when an error occurs
        return;
      }
      final url =
          Uri.parse('$baseUrl/api/EmployeeContract/GetEmployeeContracts');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'selected_workingbranchId': branchId,
          'selected_fiscal_year': fiscalYear,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        _contracts =
            jsonResponse.map((e) => EmployeeContract.fromJson(e)).toList();
      } else {
        _errorMessage = 'Failed to load notices';
      }
    } on SocketException catch (e) {
      if (e.osError != null && e.osError!.errorCode == 101) {
        _errorMessage =
            'Network is unreachable. Please check your internet connection.';
      } else {
        _errorMessage = 'Network error: ${e.message}';
      }
      log("SocketException: $_errorMessage");
    } catch (error) {
      _errorMessage = 'Error: $error';
      print("Error: $error");
    }

    _isLoading = false;
    notifyListeners();
  }
}
