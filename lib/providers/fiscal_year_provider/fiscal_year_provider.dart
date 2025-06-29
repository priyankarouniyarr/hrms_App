import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/storage/hosptial_code_storage.dart';
import 'package:hrms_app/models/fiscal_year_models/fiscalyear_id.dart';

class FiscalYearProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  List<FiscalYearModel> _fiscalYears = [];

  final SecureStorageService _secureStorageService =
      SecureStorageService(); // Use secure storage service
  final HosptialCodeStorage _hospitalCodeStorage = HosptialCodeStorage();
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  List<FiscalYearModel> get fiscalYears => _fiscalYears;
  Future<String?> _getBaseUrl() async {
    return await _hospitalCodeStorage.getBaseUrl();
  }

  Future<void> _storeBaseUrl(String baseUrl) async {
    await _hospitalCodeStorage.storeBaseUrl(baseUrl);
    log("Stored Base URL in fiscal year: $baseUrl");
  }

  Future<void> fetchFiscalYears(int branchId) async {
    _setLoading(true);

    try {
      String? token = await _secureStorageService.readData('auth_token');
      // print("Token: $token");

      if (token == null) {
        _setErrorMessage("No token found. Please log in again.");
        return;
      }
      final baseUrl = await _getBaseUrl();
      if (baseUrl == null) {
        _setErrorMessage(
            "Base URL not found. Please enter hospital code again.");
        return;
      }

      // Store the base URL to ensure it’s persisted
      await _storeBaseUrl(baseUrl);
      final response = await http.get(
        Uri.parse('$baseUrl/Account/GetUserFinancialYear'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "workingBranchId": branchId.toString(),
        },
      );
      print("Response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        print("Response status: ${response.statusCode}");
        List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isEmpty) {
          _fiscalYears = [];
          print("hello1");
        } else {
          _fiscalYears = jsonData
              .map((fiscalYear) => FiscalYearModel.fromJson(fiscalYear))
              .toList();
        }
        notifyListeners();
      } else {
        _setErrorMessage("");
      }
    } catch (e) {
      print("Error: $e"); // Log the error
      _setErrorMessage("Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  void reset() {
    _fiscalYears = [];
    _setErrorMessage("");
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearErrorMessage() {
    if (_errorMessage.isNotEmpty) {
      _errorMessage = '';
      notifyListeners();
    }
  }
}
