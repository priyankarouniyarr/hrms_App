import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/models/fiscalyear_id.dart';
import 'package:hrms_app/storage/branch_id_storage.dart';

class FiscalYearProvider with ChangeNotifier {
  bool _loading = false;
  String _errorMessage = '';
  List<FiscalYearModel> _fiscalYears = [];

  final SecureStorageService _secureStorageService =
      SecureStorageService(); // Use secure storage service

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  List<FiscalYearModel> get fiscalYears => _fiscalYears;

  Future<void> fetchFiscalYears(int branchId) async {
    _setLoading(true);

    try {
      String? token = await _secureStorageService.readData('auth_token');
      print("Token: $token");

      if (token == null) {
        _setErrorMessage("No token found. Please log in again.");
        return;
      }

      final response = await http.get(
        Uri.parse('http://45.117.153.90:5004/Account/GetUserFinancialYear'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "workingBranchId": branchId.toString(),
        },
      );

      print('Fiscal Year Fetch Status Code: ${response.statusCode}');
      print('Raw Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isEmpty) {
          _setErrorMessage("No fiscal years found.");
        } else {
          _fiscalYears = jsonData
              .map((fiscalYear) => FiscalYearModel.fromJson(fiscalYear))
              .toList();
          notifyListeners();
        }
      } else {
        _setErrorMessage(
            "Failed to fetch fiscal years: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e"); // Log the error
      _setErrorMessage("Error: $e");
    } finally {
      _setLoading(false);
    }
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
